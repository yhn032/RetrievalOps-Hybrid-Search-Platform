# search-store

BM25·벡터·Hybrid 검색을 제공하는 OpenSearch 인프라 단위.

- 기술: OpenSearch
- 성격: 인프라 컨테이너 — 직접 코드 수정 없음
- 책임: BM25 색인, 벡터 색인, Hybrid 질의
- 근거: [ADR-0002](../../docs/deliverables/adr/0002-use-opensearch.md)

색인 스키마·분석기 설정은 M1에서 확정한다. `dev`·`stg`·`prod` 구성과 환경변수는
후속 단계에서 추가한다.
