# cache

검색 응답 캐시와 무효화를 담당하는 Redis 인프라 단위.

- 기술: Redis
- 성격: 인프라 컨테이너 — 직접 코드 수정 없음
- 책임: 검색 응답 캐시, 만료·무효화 정책
- 근거: [ADR-0001](../../docs/deliverables/adr/0001-architecture-and-module-boundary.md)

캐시 키·만료·무효화 정책은 M3에서 확정한다. `dev`·`stg`·`prod` 구성과 환경변수는
후속 단계에서 추가한다.
