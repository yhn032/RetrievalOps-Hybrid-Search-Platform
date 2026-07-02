# web-ui (stg) — 검색 화면·색인 상태 대시보드 프론트엔드 (기술 미확정)
# base: debian:bookworm-slim — 중립 placeholder. 프론트엔드 기술 확정 시 base·빌드 교체.
# Base는 major tag로만 고정. 정확한 patch 버전은 M1에서 확정.
FROM debian:bookworm-slim

# 로케일/타임존 표준화
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# prod-like 비루트 사용자 (스테이징 검증; 호스트 UID/GID 정렬)
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
 && useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash app

WORKDIR /app

# TODO(M1): 프론트엔드 기술 확정 시 base·빌드 교체 (React/Node 등 임의 선정 금지)
#   확정 후: 정적 빌드 산출물 COPY + 서빙 구성 (stg는 prod와 동일 구성, 스테이징 값 사용)

USER app

# 3000: 프론트엔드 서빙 포트 placeholder — 기술 확정 시 재검토
EXPOSE 3000

# stg: prod와 동일 구성, 스테이징 값 사용 (.env.example 참고; 기술 확정 후 활성화)
# TODO(M1): CMD ["CHANGE_ME-serve", "--port", "3000"]
