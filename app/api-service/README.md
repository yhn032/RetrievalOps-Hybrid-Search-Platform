# api-service

검색 API와 작업 상태 API를 제공하는 Spring Boot 배포 단위.

- 기술: Java · Spring Boot · Spring Data JPA/QueryDSL
- 책임: 검색 질의 처리, 작업 상태 조회, 캐시 정책, metadata-store 연동
- 성격: 코드 수정 단위 — VS Code 로컬 디버깅 지원
- 연동: cache(Redis), metadata-store(MariaDB), search-store(OpenSearch),
  retrieval-service(FastAPI)
- 근거: [ADR-0001](../../docs/deliverables/adr/0001-architecture-and-module-boundary.md),
  [ADR-0003](../../docs/deliverables/adr/0003-select-metadata-db.md)

`dev`·`stg`·`prod` Dockerfile과 환경변수는 후속 단계에서 추가한다.
