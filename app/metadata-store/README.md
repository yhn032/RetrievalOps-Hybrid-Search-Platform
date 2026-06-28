# metadata-store

문서·작업 메타데이터와 작업 상태를 저장하는 MariaDB 인프라 단위.

- 기술: MariaDB
- 성격: 인프라 컨테이너 — 직접 코드 수정 없음
- 책임: 문서 메타데이터, 작업 상태, 색인 작업 이력
- 근거: [ADR-0003](../../docs/deliverables/adr/0003-select-metadata-db.md)

스키마는 M1에서 확정한다. `dev`·`stg`·`prod` 구성과 환경변수는 후속 단계에서
추가한다.
