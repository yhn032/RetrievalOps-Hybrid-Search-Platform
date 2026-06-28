#!/usr/bin/env bash
# WORKFLOW.md에서 관리 대상 Markdown 문서까지의 링크 도달성을 검사한다.
set -euo pipefail

PROJECT_DIR="${1:-${PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}}"
ROOT="$(realpath -m "$PROJECT_DIR/WORKFLOW.md")"

[ -f "$ROOT" ] || {
    echo "FAIL: WORKFLOW.md missing" >&2
    exit 1
}

# docs/{intake,origin,internal,inbox} 는 default-deny 민감 경로다(.gitignore 및
# workflow-gate.sh와 동일한 목록). 이 경로는 최상위 README.md 라우팅 문서만 추적하므로,
# 미추적 원본(.docx, .md 등)은 공개 문서 링크 그래프의 후보가 아니다. 판정은 PROJECT_DIR
# 접두를 제거한 저장소 상대 경로로 수행해, 설치 경로에 동일 이름의 세그먼트가 있어도
# 관리 디렉터리 문서가 잘못 제외되지 않도록 한다.
candidate_files() {
    for file in README.md PROJECT.md REFERENCE.md AGENTS.md CLAUDE.md; do
        [ -f "$PROJECT_DIR/$file" ] && printf '%s\n' "$PROJECT_DIR/$file"
    done
    for dir in app docs wip; do
        [ -d "$PROJECT_DIR/$dir" ] && find "$PROJECT_DIR/$dir" -type f -name '*.md' -print
    done | awk -v root="$PROJECT_DIR/" '
        {
            rel = $0
            if (substr(rel, 1, length(root)) == root) rel = substr(rel, length(root) + 1)
            if (rel ~ /^docs\/(intake|origin|internal|inbox)\// &&
                rel !~ /^docs\/(intake|origin|internal|inbox)\/README\.md$/) next
            print
        }
    '
}

declare -A CANDIDATE=()
declare -A EDGES=()
declare -A VISITED=()
mapfile -t FILES < <(candidate_files | sort -u)

CANDIDATE["$ROOT"]=1
for file in "${FILES[@]}"; do
    CANDIDATE["$(realpath -m "$file")"]=1
done

for file in "$ROOT" "${FILES[@]}"; do
    [ -f "$file" ] || continue
    source_path="$(realpath -m "$file")"
    while IFS= read -r token; do
        link="${token#']('}"; link="${link%')'}"; link="${link%%#*}"
        case "$link" in
            ''|http://*|https://*|mailto:*) continue ;;
        esac
        target="$(realpath -m "$(dirname "$file")/$link")"
        [ -e "$target" ] || {
            echo "FAIL: ${file#"$PROJECT_DIR"/} -> $link is missing" >&2
            exit 1
        }
        if [ -n "${CANDIDATE[$target]:-}" ]; then
            EDGES["$source_path"]+="$target"$'\n'
        fi
    done < <(grep -Eo '\]\([^)]+\)' "$file" || true)
done

QUEUE=("$ROOT")
VISITED["$ROOT"]=1
while [ "${#QUEUE[@]}" -gt 0 ]; do
    current="${QUEUE[0]}"
    QUEUE=("${QUEUE[@]:1}")
    while IFS= read -r target; do
        [ -n "$target" ] || continue
        if [ -z "${VISITED[$target]:-}" ]; then
            VISITED["$target"]=1
            QUEUE+=("$target")
        fi
    done <<< "${EDGES[$current]:-}"
done

FAIL=0
for file in "${!CANDIDATE[@]}"; do
    [ -n "${VISITED[$file]:-}" ] && continue
    echo "FAIL: unreachable document ${file#"$PROJECT_DIR"/}" >&2
    FAIL=1
done

[ "$FAIL" -eq 0 ] || exit 1
echo "PASS: docs link check (${#CANDIDATE[@]} reachable documents)"
