# search-store (OpenSearch) — DEV
# BM25 + vector + hybrid 검색 스토어. 앱 코드 없음(인프라 컨테이너).
# 공식 이미지 위 thin layer: config bake + TZ/UTF-8 통일만 수행.
# Base는 major 태그로 고정 — 정확한 patch 버전은 M1에서 확정.
FROM opensearchproject/opensearch:2

# TZ / UTF-8 통일
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# TODO(M1): bake cluster config (opensearch.yml / log4j2.properties 등)
#   COPY config/dev/opensearch.yml /usr/share/opensearch/config/opensearch.yml
# dev: single-node + security plugin 비활성 가능 + verbose logging 허용(디버그 친화).

EXPOSE 9200

# 공식 이미지의 내장 비루트 사용자(opensearch, uid 1000)로 실행.
USER opensearch

# dev healthcheck: security off → plain http
HEALTHCHECK --interval=30s --timeout=5s --retries=5 \
  CMD curl -fsS http://localhost:9200/_cluster/health || exit 1
