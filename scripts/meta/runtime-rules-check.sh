#!/usr/bin/env bash
# app/ 배포 단위 Dockerfile의 런타임 규칙을 검사한다.
# 규칙: 타임존(TZ=UTC), 인코딩(C.UTF-8), 코드 수정 단위는 비루트 USER와
# 호스트 UID/GID 인자(HOST_UID/HOST_GID)를 갖춰야 한다. 인프라 단위는 명시
# USER가 있거나, 공식 entrypoint의 비루트 권한 드롭을 설명하는 주석이 있어야
# 한다(예: metadata-store — "공식 entrypoint가 mysql 유저로 권한을 드롭한다").
set -euo pipefail

PROJECT_DIR="${1:-${PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}}"
APP="$PROJECT_DIR/app"
CODE_UNITS="api-service retrieval-service index-worker model-serving web-ui"
FAIL=0

fail() { echo "FAIL: $*" >&2; FAIL=1; }
is_code_unit() { case " $CODE_UNITS " in *" $1 "*) return 0 ;; *) return 1 ;; esac; }

[ -d "$APP" ] || { echo "FAIL: app/ 없음" >&2; exit 1; }

count=0
while IFS= read -r df; do
    count=$((count + 1))
    rel="${df#"$PROJECT_DIR"/}"
    unit="$(printf '%s' "$rel" | cut -d/ -f2)"
    grep -Eq 'TZ=UTC' "$df" || fail "$rel: TZ=UTC 누락"
    grep -Eq 'C\.UTF-8' "$df" || fail "$rel: C.UTF-8 로케일 누락"
    if is_code_unit "$unit"; then
        grep -Eq '^USER ' "$df" || fail "$rel: 비루트 USER 누락"
        grep -Eq 'HOST_UID' "$df" || fail "$rel: HOST_UID 인자 누락"
        grep -Eq 'HOST_GID' "$df" || fail "$rel: HOST_GID 인자 누락"
    else
        grep -Eq '^USER ' "$df" || grep -q '권한을 드롭' "$df" ||
            fail "$rel: 비루트 USER 또는 공식 entrypoint 권한 드롭 주석 누락"
    fi
done < <(find "$APP" -name Dockerfile | sort)

[ "$count" -eq 27 ] || fail "Dockerfile 수가 27이 아님: $count"

[ "$FAIL" -eq 0 ] || { echo "런타임 규칙 검사 실패." >&2; exit 1; }
echo "PASS: runtime rules ($count Dockerfiles)"
