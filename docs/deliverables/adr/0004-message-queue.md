---
document-id: deliverable-adr-0004-message-queue
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-29
source: intake-side-project-charter
sensitivity: public
---

# ADR 0004 — 메시지 큐 도입 여부

## 맥락

비동기 수집·청킹·색인 파이프라인은 작업 큐, 재시도, 중복 방지, 상태 조회가
필요하다(FR-5·FR-6). 차터는 정당화할 수 없는 구성요소를 제거하라고 명시한다.

## 결정

메시지 큐로 RabbitMQ를 채택해 비동기 색인 작업을 발행·소비한다. 재시도와 실패
격리는 RabbitMQ의 재큐·DLQ로 처리한다.

## 근거

- 비동기 파이프라인의 작업 분리·재시도·DLQ를 표준 브로커로 명확히 구현하고,
  운영형 백엔드(M3)의 메시징 역량을 포트폴리오로 보여준다.
- 모델 추론이 model-serving으로 분리([ADR-0007](0007-model-serving.md))되어 워커가
  가벼워지므로 큐 기반 비동기 처리에 집중하기 좋다.

## 대안

- DB 작업 테이블 + 폴링: 단순하지만 재시도·팬아웃·관측이 제한적이고 메시징 역량을
  드러내지 못해 기각(소규모 로컬 검증에는 충분).
- Kafka: 로그 스트리밍급 규모가 아니라 과함으로 기각.

## 결과

- `message-queue`(RabbitMQ)를 인프라 배포 단위로 기동한다.
- api-service가 색인 작업을 발행하고 index-worker가 소비한다.
- 큐·교환기·DLQ 설계는 M3에서 확정한다.
