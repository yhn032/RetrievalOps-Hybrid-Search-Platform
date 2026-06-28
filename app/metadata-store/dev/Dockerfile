# metadata-store (dev) — MariaDB for document/job metadata
# 공식 이미지 위 thin layer: TZ / UTF-8 / 선택적 init 스크립트만 추가.
# 정확한 patch 버전은 M1에서 확정한다 (major 태그만 고정).
FROM mariadb:11

# 시간대 및 로케일 (UTF-8 강제)
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# dev: 단일 노드, 디버깅 친화적. 공식 entrypoint가 mysql 유저로 권한을 드롭한다.
# 인증/스키마 값은 .env.example 참고.

# TODO(M1): 초기 스키마/시드가 생기면 init 스크립트를 마운트한다.
#   docker-entrypoint-initdb.d 의 *.sql / *.sh 는 최초 부팅 시 자동 실행됨.
# COPY ./initdb/ /docker-entrypoint-initdb.d/

EXPOSE 3306

# utf8mb4 + general log (dev 전용 디버깅)
CMD ["--character-set-server=utf8mb4", \
     "--collation-server=utf8mb4_unicode_ci", \
     "--general-log=1"]
