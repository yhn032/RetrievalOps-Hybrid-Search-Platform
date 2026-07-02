# index-worker

비동기 수집·색인 파이프라인을 수행하는 Java·Spring 워커 배포 단위.

- 기술: Java · Spring (비동기·재시도)
- 책임: 수집 → 파싱 → 청킹 → 임베딩(model-serving 호출) → 색인, 재시도·중복 방지,
  작업 상태 기록
- 성격: 코드 수정 단위 — VS Code 로컬 디버깅 지원 (워커 프로세스, inbound HTTP 포트 없음)
- 작업 큐: message-queue(RabbitMQ)의 색인 작업을 소비 — api-service가 발행,
  재시도·실패 격리는 재큐·DLQ로 처리
- 연동: message-queue(RabbitMQ), model-serving(임베딩 REST),
  search-store(OpenSearch), metadata-store(MariaDB)
- 근거: [ADR-0006](../../docs/deliverables/adr/0006-index-worker-language.md),
  [ADR-0004](../../docs/deliverables/adr/0004-message-queue.md)

`dev`·`stg`·`prod` Dockerfile과 환경변수는 스캐폴드이며, 실제 앱 코드는 M1 이후 추가한다.
