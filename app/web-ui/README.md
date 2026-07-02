# web-ui

검색 화면과 색인 상태 대시보드를 제공하는 프론트엔드 배포 단위.

- 기술: 미확정 — [PROJECT.md](../../PROJECT.md) "기술 추후". 확정 시점은 문서에
  별도 정의가 없으므로, 기술 확정 시 base·빌드를 교체한다.
- 책임: 검색 화면, 색인 상태 대시보드
- 성격: 코드 수정 단위 — VS Code 로컬 디버깅 지원
- 연동: api-service(REST, 브라우저 경유)
- 근거: [ADR-0001](../../docs/deliverables/adr/0001-architecture-and-module-boundary.md),
  [ADR-0008](../../docs/deliverables/adr/0008-search-availability.md) — 검색 가용성과 별개

`dev`·`stg`·`prod` Dockerfile은 중립 placeholder(debian:bookworm-slim)로 런타임
규칙(TZ=UTC·UTF-8·HOST_UID/GID·비루트 USER)만 충족한다. 실제 앱 코드는 M1 이후
추가하며, 프론트엔드 기술 확정 시 base·빌드를 교체한다.
