# metadata-store (stg) — MariaDB for document/job metadata
# prod 구성과 동일하게 두되 값만 staging 으로. thin layer (TZ / UTF-8 / init).
# 정확한 patch 버전은 M1에서 확정한다 (major 태그만 고정).
FROM mariadb:11

# 시간대 및 로케일 (UTF-8 강제)
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# stg: prod-like. 공식 entrypoint가 mysql 유저로 권한을 드롭한다.

# TODO(M1): 초기 스키마/시드가 생기면 init 스크립트를 마운트한다.
# COPY ./initdb/ /docker-entrypoint-initdb.d/

EXPOSE 3306

# utf8mb4. general log 비활성(운영 유사), slow query log 만 유지.
CMD ["--character-set-server=utf8mb4", \
     "--collation-server=utf8mb4_unicode_ci", \
     "--slow-query-log=1"]
