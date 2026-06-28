#!/usr/bin/env bash
# 프로젝트 문서의 배치, 메타데이터, 상태, 출처와 기준본 변경을 검사한다.
set -euo pipefail

PROJECT_DIR="${1:-${PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}}"
MANIFEST="$PROJECT_DIR/docs/standards/MANIFEST.md"
FAIL=0

fail() {
    echo "FAIL: $*" >&2
    FAIL=1
}

frontmatter() {
    awk 'NR == 1 && $0 == "---" { inside=1; next }
         inside && $0 == "---" { exit }
         inside { print }' "$1"
}

field() {
    frontmatter "$1" | sed -n "s/^$2:[[:space:]]*//p" | head -1
}

managed_files() {
    [ -f "$PROJECT_DIR/WORKFLOW.md" ] && printf '%s\n' "$PROJECT_DIR/WORKFLOW.md"
    find "$PROJECT_DIR/docs/standards" -maxdepth 1 -type f -name '*.md' ! -name README.md -print 2>/dev/null
    for role in deliverables derived research; do
        find "$PROJECT_DIR/docs/$role" -type f -name '*.md' ! -name README.md -print 2>/dev/null
    done
}

expected_role() {
    case "${1#"$PROJECT_DIR"/}" in
        WORKFLOW.md|docs/standards/*) echo standard ;;
        docs/deliverables/*) echo deliverable ;;
        docs/derived/*) echo derived ;;
        docs/research/*) echo research ;;
        *) return 1 ;;
    esac
}

is_managed_path() {
    case "$1" in
        WORKFLOW.md|docs/standards/*.md|docs/deliverables/*.md|docs/deliverables/**/*.md|docs/derived/*.md|docs/derived/**/*.md|docs/research/*.md|docs/research/**/*.md)
            [ "$(basename "$1")" != README.md ]
            ;;
        *) return 1 ;;
    esac
}

[ -f "$MANIFEST" ] || {
    echo "FAIL: missing docs/standards/MANIFEST.md" >&2
    exit 1
}

declare -A IDS=()
mapfile -t MANAGED < <(managed_files | sort)

for file in "${MANAGED[@]}"; do
    rel="${file#"$PROJECT_DIR"/}"
    [ "$(head -1 "$file" 2>/dev/null)" = "---" ] || {
        fail "$rel: frontmatter missing"
        continue
    }
    [ "$(grep -c '^---$' "$file" 2>/dev/null)" -ge 2 ] || {
        fail "$rel: frontmatter is not closed"
        continue
    }

    for key in document-id role stage status owner updated source sensitivity; do
        [ -n "$(field "$file" "$key")" ] || fail "$rel: missing $key"
    done

    id="$(field "$file" document-id)"
    if [[ ! "$id" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
        fail "$rel: invalid document-id '$id'"
    elif [ -n "${IDS[$id]:-}" ]; then
        fail "$rel: duplicate document-id '$id' (${IDS[$id]})"
    else
        IDS[$id]="$rel"
    fi

    role="$(field "$file" role)"
    expected="$(expected_role "$file" || true)"
    [ "$role" = "$expected" ] || fail "$rel: role '$role' does not match '$expected'"

    stage="$(field "$file" stage)"
    stage="${stage#\"}"; stage="${stage%\"}"
    [[ "$stage" =~ ^0[0-9]$ ]] || fail "$rel: invalid stage '$stage'"

    status="$(field "$file" status)"
    [[ "$status" =~ ^(template|drafted|approved|excluded)$ ]] || fail "$rel: invalid status '$status'"
    if [ "$status" = excluded ] && [ -z "$(field "$file" exclusion-reason)" ]; then
        fail "$rel: excluded status requires exclusion-reason"
    fi

    updated="$(field "$file" updated)"
    [[ "$updated" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || fail "$rel: invalid updated date '$updated'"
    [ "$(field "$file" sensitivity)" = public ] || fail "$rel: tracked document must be public"

    source="$(field "$file" source)"
    if [ "$role" = derived ] && [ "$source" = internal ]; then
        fail "$rel: derived document requires an original path or source ID"
    fi
    if [ "$role" = research ] && [[ ! "$source" =~ ^https?:// ]]; then
        fail "$rel: research document requires a public URL source"
    fi
done

# 단계 문서의 상태와 MANIFEST 상태는 같아야 한다.
for file in "$PROJECT_DIR"/docs/standards/[0-9][0-9]-*.md; do
    [ -f "$file" ] || continue
    stage="$(basename "$file" | cut -c1-2)"
    actual="$(field "$file" status)"
    expected="$(awk -F'|' -v stage="$stage" '
        $2 ~ "^[[:space:]]*" stage "([[:space:]]|$)" {
            gsub(/[ `]/, "", $5); print $5
        }' "$MANIFEST")"
    [ -n "$expected" ] || fail "MANIFEST.md: stage $stage missing"
    [ "$actual" = "$expected" ] || fail "$(basename "$file"): status '$actual' differs from MANIFEST '$expected'"
done

# 민감 경로에는 README 외 추적 파일이 없어야 하고 default-deny가 적용되어야 한다.
if git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    for dir in intake origin internal inbox; do
        while IFS= read -r tracked; do
            [ -z "$tracked" ] && continue
            [ "$tracked" = "docs/$dir/README.md" ] || fail "$tracked: sensitive role path must not be tracked"
        done < <(git -C "$PROJECT_DIR" ls-files "docs/$dir/**")
        git -C "$PROJECT_DIR" check-ignore -q "docs/$dir/.workflow-gate-probe" ||
            fail "docs/$dir: default-deny ignore rule missing"
        if git -C "$PROJECT_DIR" check-ignore -q "docs/$dir/README.md"; then
            fail "docs/$dir/README.md: routing README must remain trackable"
        fi
    done
fi

# 기준본은 승인된 원문과 동일해야 한다.
for baseline in "$PROJECT_DIR"/docs/standards/_baseline/*.md; do
    [ -f "$baseline" ] || continue
    [ "$(basename "$baseline")" = README.md ] && continue
    source_file="$PROJECT_DIR/docs/standards/$(basename "$baseline")"
    [ -f "$source_file" ] || {
        fail "${baseline#"$PROJECT_DIR"/}: source standard missing"
        continue
    }
    [ "$(field "$source_file" status)" = approved ] ||
        fail "${baseline#"$PROJECT_DIR"/}: source standard is not approved"
    cmp -s "$source_file" "$baseline" ||
        fail "${baseline#"$PROJECT_DIR"/}: baseline differs from approved source"
done

# staged 변경이 있으면 상태-only 변경과 무단 rebaseline을 검사한다.
if git -C "$PROJECT_DIR" rev-parse --verify HEAD >/dev/null 2>&1; then
    while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        is_managed_path "$rel" || continue
        git -C "$PROJECT_DIR" cat-file -e "HEAD:$rel" 2>/dev/null || continue
        old_status="$(git -C "$PROJECT_DIR" show "HEAD:$rel" | sed -n '1,/^---$/s/^status:[[:space:]]*//p')"
        new_status="$(git -C "$PROJECT_DIR" show ":$rel" | sed -n '1,/^---$/s/^status:[[:space:]]*//p')"
        if [ "$old_status" != "$new_status" ] &&
            cmp -s \
                <(git -C "$PROJECT_DIR" show "HEAD:$rel" | sed '/^status:[[:space:]]*/d; /^updated:[[:space:]]*/d') \
                <(git -C "$PROJECT_DIR" show ":$rel" | sed '/^status:[[:space:]]*/d; /^updated:[[:space:]]*/d'); then
            fail "$rel: status changed without document content or reason"
        fi
    done < <(git -C "$PROJECT_DIR" diff --cached --name-only --diff-filter=AM)

    baseline_changed="$(git -C "$PROJECT_DIR" diff --cached --name-only --diff-filter=AMRD -- docs/standards/_baseline |
        grep -v '/README.md$' || true)"
    if [ -n "$baseline_changed" ] && [ "${WORKFLOW_REBASELINE:-0}" != 1 ]; then
        fail "baseline changed without a Rebaseline: commit reason"
    fi
fi

if [ "$FAIL" -ne 0 ]; then
    echo "Workflow gate failed." >&2
    exit 1
fi

echo "PASS: workflow gate (${#MANAGED[@]} managed documents)"
