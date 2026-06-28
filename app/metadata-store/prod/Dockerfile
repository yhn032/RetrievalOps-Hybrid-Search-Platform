# metadata-store (prod) — MariaDB for document/job metadata
# 최소 런타임. thin layer (TZ / UTF-8 / init). 디버깅 도구 없음.
# 정확한 patch 버전은 M1에서 확정한다 (major 태그만 고정).
FROM mariadb:11

# 시간대 및 로케일 (UTF-8 강제)
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# prod: 공식 entrypoint가 mysql(비-root) 유저로 권한을 드롭한다.
# 자격증명은 .env 파일이 아니라 secret manager / *_FILE 변수로 주입한다.
#   예: MARIADB_ROOT_PASSWORD_FILE, MARIADB_PASSWORD_FILE → 마운트된 secret 경로.

# TODO(M1): 초기 스키마/시드가 생기면 init 스크립트를 마운트한다.
# COPY ./initdb/ /docker-entrypoint-initdb.d/

EXPOSE 3306

# utf8mb4. 디버깅 로그 비활성(general log off), 운영 안정성 우선.
CMD ["--character-set-server=utf8mb4", \
     "--collation-server=utf8mb4_unicode_ci", \
     "--skip-name-resolve"]
