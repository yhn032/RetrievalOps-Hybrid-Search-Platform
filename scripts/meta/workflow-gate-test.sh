#!/usr/bin/env bash
# workflow gate의 정상 경로와 주요 위반 탐지를 격리 fixture에서 검증한다.
set -euo pipefail

SOURCE_ROOT="${1:-${PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}}"
GATE="$SOURCE_ROOT/scripts/meta/workflow-gate.sh"
LINK_CHECK="$SOURCE_ROOT/scripts/meta/docs-link-check.sh"
TMP_ROOT="$(mktemp -d)"
PASS=0
FAIL=0
trap 'find "$TMP_ROOT" -depth -delete 2>/dev/null || true' EXIT

record_pass() { PASS=$((PASS + 1)); echo "PASS: $1"; }
record_fail() { FAIL=$((FAIL + 1)); echo "FAIL: $1" >&2; }

expect_pass() {
    label=$1; shift
    if "$@" >/dev/null 2>&1; then record_pass "$label"; else record_fail "$label"; fi
}

expect_fail() {
    label=$1; shift
    if "$@" >/dev/null 2>&1; then record_fail "$label"; else record_pass "$label"; fi
}

make_fixture() {
    name=$1
    root="${2:-$TMP_ROOT/$name}"
    mkdir -p "$root/docs/standards/_baseline" "$root/docs/derived" \
        "$root/docs/deliverables" "$root/docs/research" \
        "$root/docs/intake" "$root/docs/origin" "$root/docs/internal" "$root/docs/inbox"

    cat > "$root/.gitignore" <<'EOF'
/docs/intake/**
!/docs/intake/README.md
/docs/origin/**
!/docs/origin/README.md
/docs/internal/**
!/docs/internal/README.md
/docs/inbox/**
!/docs/inbox/README.md
EOF
    cat > "$root/WORKFLOW.md" <<'EOF'
---
document-id: workflow-router
role: standard
stage: "00"
status: drafted
owner: tester
updated: 2026-06-28
source: internal
sensitivity: public
---
# Workflow
[Docs](docs/README.md)
EOF
    cat > "$root/docs/README.md" <<'EOF'
# Docs
[Standards](standards/README.md)
[Derived](derived/README.md)
[Deliverables](deliverables/README.md)
[Research](research/README.md)
[Intake](intake/README.md)
[Origin](origin/README.md)
[Internal](internal/README.md)
[Inbox](inbox/README.md)
EOF
    cat > "$root/docs/standards/README.md" <<'EOF'
# Standards
[Manifest](MANIFEST.md)
[00](00-common.md)
[Baseline](_baseline/README.md)
EOF
    cat > "$root/docs/standards/MANIFEST.md" <<'EOF'
---
document-id: lifecycle-manifest
role: standard
stage: "00"
status: drafted
owner: tester
updated: 2026-06-28
source: internal
sensitivity: public
---
# Manifest
| 단계 | 표준 | 적용 | 상태 | 근거 |
|---|---|---|---|---|
| 00 | [00](00-common.md) | 필수 | `template` | fixture |
EOF
    cat > "$root/docs/standards/00-common.md" <<'EOF'
---
document-id: standard-00-common
role: standard
stage: "00"
status: template
owner: tester
updated: 2026-06-28
source: internal
sensitivity: public
---
# Common
Template content.
EOF
    cat > "$root/docs/derived/analysis.md" <<'EOF'
---
document-id: derived-analysis
role: derived
stage: "01"
status: drafted
owner: tester
updated: 2026-06-28
source: intake-source-001
sensitivity: public
---
# Analysis
Derived content.
EOF
    cat > "$root/docs/derived/README.md" <<'EOF'
# Derived
[Analysis](analysis.md)
[External](https://example.com)
EOF
    for dir in deliverables research intake origin internal inbox; do
        printf '# %s\n' "$dir" > "$root/docs/$dir/README.md"
    done
    printf '# Baseline\n' > "$root/docs/standards/_baseline/README.md"

    git -C "$root" init -q -b main
    git -C "$root" config user.name tester
    git -C "$root" config user.email tester@example.com
    git -C "$root" add .
    git -C "$root" commit -q -m baseline
    printf '%s\n' "$root"
}

valid="$(make_fixture valid)"
expect_pass "valid workflow" bash "$GATE" "$valid"
expect_pass "valid link graph" bash "$LINK_CHECK" "$valid"

missing_metadata="$(make_fixture missing-metadata)"
sed -i '/^owner:/d' "$missing_metadata/docs/standards/00-common.md"
expect_fail "missing metadata detected" bash "$GATE" "$missing_metadata"

excluded="$(make_fixture excluded)"
sed -i 's/status: template/status: excluded/' "$excluded/docs/standards/00-common.md"
expect_fail "excluded reason required" bash "$GATE" "$excluded"

source_gap="$(make_fixture source-gap)"
sed -i 's/source: intake-source-001/source: internal/' "$source_gap/docs/derived/analysis.md"
expect_fail "derived source required" bash "$GATE" "$source_gap"

orphan="$(make_fixture orphan)"
cp "$orphan/docs/derived/analysis.md" "$orphan/docs/deliverables/orphan.md"
sed -i 's/document-id: derived-analysis/document-id: deliverable-orphan/; s/role: derived/role: deliverable/' \
    "$orphan/docs/deliverables/orphan.md"
expect_fail "orphan document detected" bash "$LINK_CHECK" "$orphan"

broken="$(make_fixture broken-link)"
printf '[Broken](missing.md)\n' >> "$broken/docs/README.md"
expect_fail "broken link detected" bash "$LINK_CHECK" "$broken"

# 민감 경로(default-deny)의 미추적 원본 .md 는 링크 그래프 후보가 아니므로
# 도달 불가로 잡히지 않아야 한다. orphan 테스트(deliverables)는 여전히 탐지된다.
sensitive_md="$(make_fixture sensitive-md)"
printf '# 원본\n전달받은 미추적 원본 자료.\n' > "$sensitive_md/docs/intake/ORIGINAL.md"
expect_pass "untracked sensitive .md ignored by link check" bash "$LINK_CHECK" "$sensitive_md"

# 기준본 스냅샷(_baseline의 README 외 .md)은 더 깊은 경로라 상대 링크가 깨지지만
# 링크 그래프 후보가 아니므로 검사에서 제외되어야 한다.
baseline_md="$(make_fixture baseline-snapshot)"
printf '# 스냅샷\n[깨진링크](../../nope.md)\n' > "$baseline_md/docs/standards/_baseline/00-common.md"
expect_pass "baseline snapshot excluded from link check" bash "$LINK_CHECK" "$baseline_md"

# PROJECT_DIR 경로 자체에 민감 세그먼트(/docs/intake/ 등)가 포함돼도 관리 디렉터리의
# 진짜 orphan을 놓치지 않아야 한다. 절대 경로가 아닌 저장소 상대 경로로 판정하는지 검증.
poisoned="$(make_fixture poisoned "$TMP_ROOT/docs/intake/host/proj")"
cp "$poisoned/docs/derived/analysis.md" "$poisoned/docs/derived/orphan.md"
sed -i 's/document-id: derived-analysis/document-id: derived-orphan/' "$poisoned/docs/derived/orphan.md"
expect_fail "orphan detected under sensitive-segment PROJECT_DIR" bash "$LINK_CHECK" "$poisoned"

status_only="$(make_fixture status-only)"
sed -i 's/status: template/status: drafted/' "$status_only/docs/standards/00-common.md"
sed -i 's/`template`/`drafted`/' "$status_only/docs/standards/MANIFEST.md"
git -C "$status_only" add docs/standards
expect_fail "status-only change detected" bash "$GATE" "$status_only"

status_only_reason="$(make_fixture status-only-reason)"
sed -i 's/status: template/status: drafted/' "$status_only_reason/docs/standards/00-common.md"
sed -i 's/`template`/`drafted`/' "$status_only_reason/docs/standards/MANIFEST.md"
git -C "$status_only_reason" add docs/standards
expect_pass "status-only change accepted with rebaseline reason" env WORKFLOW_REBASELINE=1 bash "$GATE" "$status_only_reason"

sensitive="$(make_fixture sensitive)"
printf 'secret\n' > "$sensitive/docs/intake/secret.md"
git -C "$sensitive" add -f docs/intake/secret.md
expect_fail "tracked sensitive source detected" bash "$GATE" "$sensitive"

rebaseline="$(make_fixture rebaseline)"
sed -i 's/status: template/status: approved/' "$rebaseline/docs/standards/00-common.md"
sed -i 's/`template`/`approved`/' "$rebaseline/docs/standards/MANIFEST.md"
printf 'Approved content.\n' >> "$rebaseline/docs/standards/00-common.md"
cp "$rebaseline/docs/standards/00-common.md" "$rebaseline/docs/standards/_baseline/00-common.md"
git -C "$rebaseline" add docs/standards
expect_fail "baseline reason required" bash "$GATE" "$rebaseline"
expect_pass "rebaseline reason accepted" env WORKFLOW_REBASELINE=1 bash "$GATE" "$rebaseline"

baseline_delete="$(make_fixture baseline-delete)"
sed -i 's/status: template/status: approved/' "$baseline_delete/docs/standards/00-common.md"
sed -i 's/`template`/`approved`/' "$baseline_delete/docs/standards/MANIFEST.md"
printf 'Approved content.\n' >> "$baseline_delete/docs/standards/00-common.md"
cp "$baseline_delete/docs/standards/00-common.md" "$baseline_delete/docs/standards/_baseline/00-common.md"
git -C "$baseline_delete" add docs/standards
git -C "$baseline_delete" commit -q -m 'approved baseline'
git -C "$baseline_delete" rm -q docs/standards/_baseline/00-common.md
expect_fail "baseline deletion reason required" bash "$GATE" "$baseline_delete"
expect_pass "rebaseline deletion accepted" env WORKFLOW_REBASELINE=1 bash "$GATE" "$baseline_delete"

echo "Workflow gate tests: $PASS PASS / $FAIL FAIL"
[ "$FAIL" -eq 0 ]
