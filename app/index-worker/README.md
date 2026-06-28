# index-worker

비동기 수집·색인 파이프라인 배포 단위.

- 기술: Python
- 책임: 수집 → 파싱 → 청킹 → 임베딩 → 색인, 재시도·중복 방지, 작업 상태 기록
- 성격: 코드 수정 단위 — VS Code 로컬 디버깅 지원
- 작업 큐: 초기에는 DB 작업 테이블, 필요 시 RabbitMQ로 확장
- 근거: [ADR-0006](../../docs/deliverables/adr/0006-index-worker-language.md),
  [ADR-0004](../../docs/deliverables/adr/0004-message-queue.md)

`dev`·`stg`·`prod` Dockerfile과 환경변수는 후속 단계에서 추가한다.
