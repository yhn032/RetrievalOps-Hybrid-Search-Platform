# search-store (OpenSearch) — STG (prod-like, staging 값)
# BM25 + vector + hybrid 검색 스토어. 앱 코드 없음(인프라 컨테이너).
# 공식 이미지 위 thin layer: config bake + TZ/UTF-8 통일만 수행.
# Base는 major 태그로 고정 — 정확한 patch 버전은 M1에서 확정.
FROM opensearchproject/opensearch:2

# TZ / UTF-8 통일
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# TODO(M1): bake cluster config (opensearch.yml / seed_hosts 등)
#   COPY config/stg/opensearch.yml /usr/share/opensearch/config/opensearch.yml
# stg: prod 토폴로지 미러(멀티노드 디스커버리) + security plugin 활성.

EXPOSE 9200

# 공식 이미지의 내장 비루트 사용자(opensearch, uid 1000)로 실행.
USER opensearch

# stg healthcheck: security on → https + admin 인증
HEALTHCHECK --interval=30s --timeout=5s --retries=5 \
  CMD curl -fsS -k -u admin:"${OPENSEARCH_INITIAL_ADMIN_PASSWORD}" \
    https://localhost:9200/_cluster/health || exit 1
