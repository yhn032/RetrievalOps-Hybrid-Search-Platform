#!/usr/bin/env bash
# =============================================================================
# git-credential-helper.sh — 토큰 무흔적 Git 인증 헬퍼
# =============================================================================
# .devcontainer/.env 의 GIT_PUSH_USER / GIT_PUSH_TOKEN 을 런타임에 읽어
# git 에 자격증명을 공급한다. 토큰을 .git/config·명령행·추적 파일에 남기지
# 않기 위한 휘발성 헬퍼다. (이 스크립트 자체에는 비밀이 없다.)
#
# 사용:
#   git config --local credential.helper "$PWD/scripts/git/git-credential-helper.sh"
#   git push -u origin develop
# 또는 1회성:
#   git -c credential.helper="$PWD/scripts/git/git-credential-helper.sh" push ...
# =============================================================================
set -euo pipefail

# get 동작에만 응답. store/erase 는 무시(어디에도 저장하지 않음).
[ "${1:-}" = "get" ] || exit 0

ENV_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.devcontainer/.env"
[ -f "$ENV_FILE" ] || exit 0

# 값만 추출(소싱 부작용 회피). 앞뒤 따옴표 제거.
read_val() {
  grep -E "^$1=" "$ENV_FILE" | head -1 | cut -d= -f2- | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'\$//"
}
user="$(read_val GIT_PUSH_USER || true)"
token="$(read_val GIT_PUSH_TOKEN || true)"

[ -n "$user" ]  && printf 'username=%s\n' "$user"
[ -n "$token" ] && printf 'password=%s\n' "$token"
exit 0
