# retrieval-service

임베딩·Reranker·검색 품질 평가를 담당하는 FastAPI 배포 단위.

- 기술: Python · FastAPI
- 책임: 문서·질의 임베딩, Dense 검색, Reranker 적용, 평가 지표 산출
- 성격: 코드 수정 단위 — VS Code 로컬 디버깅 지원
- 연동: search-store(OpenSearch), api-service(Spring Boot)
- 근거: [ADR-0001](../../docs/deliverables/adr/0001-architecture-and-module-boundary.md),
  [ADR-0002](../../docs/deliverables/adr/0002-use-opensearch.md)

`dev`·`stg`·`prod` Dockerfile과 환경변수는 후속 단계에서 추가한다.
