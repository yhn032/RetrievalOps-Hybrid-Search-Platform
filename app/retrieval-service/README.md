# retrieval-service

Dense·Hybrid 결합과 검색 오케스트레이션을 담당하는 FastAPI 배포 단위.

- 기술: Python · FastAPI
- 책임: Dense·Hybrid 결합, 검색 오케스트레이션, 평가 지표 산출 — 임베딩·Reranker
  추론은 model-serving을 REST로 호출한다(ADR-0007)
- 성격: 코드 수정 단위 — VS Code 로컬 디버깅 지원
- 연동: search-store(OpenSearch), model-serving(REST), api-service(Spring Boot)
- 근거: [ADR-0001](../../docs/deliverables/adr/0001-architecture-and-module-boundary.md),
  [ADR-0002](../../docs/deliverables/adr/0002-use-opensearch.md),
  [ADR-0007](../../docs/deliverables/adr/0007-model-serving.md)

`dev`·`stg`·`prod` Dockerfile과 환경변수는 스캐폴드이며, 실제 앱 코드는 M1 이후
추가한다.
