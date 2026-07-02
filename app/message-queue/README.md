# message-queue

색인 작업의 발행·소비를 중개하는 RabbitMQ 인프라 단위.

- 기술: RabbitMQ
- 성격: 인프라 컨테이너 — 직접 코드 수정 없음
- 책임: 색인 작업 큐, 재시도(재큐), DLQ(실패 격리)
- 발행자: api-service — `POST /index` 요청을 색인 작업으로 발행
- 소비자: index-worker — 큐를 소비해 수집→파싱→청킹→색인 수행
- 포트: AMQP 5672, management UI 15672(dev 전용)
- 근거: [ADR-0004](../../docs/deliverables/adr/0004-message-queue.md)

큐·교환기·DLQ 설계는 M3에서 확정한다. `dev`·`stg`·`prod` 구성과 환경변수는 각
하위 디렉터리의 `Dockerfile`·`.env.example`을 참고한다.
