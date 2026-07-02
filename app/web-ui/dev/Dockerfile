# web-ui (dev) — 검색 화면·색인 상태 대시보드 프론트엔드 (기술 미확정)
# base: debian:bookworm-slim — 중립 placeholder. 프론트엔드 기술 확정 시 base·빌드 교체.
# Base는 major tag로만 고정. 정확한 patch 버전은 M1에서 확정.
FROM debian:bookworm-slim

# 로케일/타임존 표준화
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# 호스트 UID/GID와 일치하는 비루트 사용자 (VS Code bind-mount 편집 권한 정렬)
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
 && useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash app

WORKDIR /app

# TODO(M1): 프론트엔드 기술 확정 시 base·빌드 교체 (React/Node 등 임의 선정 금지)
#   확정 후: 의존성 설치 + 소스 bind-mount + dev 서버(hot reload)로 실행

USER app

# 3000: 프론트엔드 dev 서버 관례 포트 placeholder — 기술 확정 시 재검토
EXPOSE 3000

# dev: 기술 확정 전까지 진입점 없음 (확정 후 dev 서버 CMD 활성화)
# TODO(M1): CMD ["CHANGE_ME-dev-server", "--port", "3000"]
