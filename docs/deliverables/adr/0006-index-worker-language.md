---
document-id: deliverable-adr-0006-index-worker-language
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-29
source: intake-side-project-charter
sensitivity: public
---

# ADR 0006 — 색인 워커 구현 언어

## 맥락

색인 워커는 수집→파싱→청킹→임베딩→색인을 수행한다(FR-5). 차터는 구현 언어를
Python 또는 Java 중 M0에서 결정하도록 했다.

## 결정

색인 워커를 Java(Spring 기반 비동기·재시도)로 구현한다.

## 근거

- 모델 임베딩이 model-serving으로 분리([ADR-0007](0007-model-serving.md))되어 워커는
  수집·파싱·청킹·색인 오케스트레이션과 재시도에 집중한다. Python 임베딩 스택을
  워커에 둘 이유가 줄었다.
- api-service와 같은 Java·Spring 스택을 공유하고, Spring 비동기·재시도·메시징
  (RabbitMQ, [ADR-0004](0004-message-queue.md)) 운영 역량을 포트폴리오로 보여준다.

## 대안

- Python 구현: 임베딩 생태계와 가깝지만 모델 분리 후 이점이 줄고 Java 비동기 시연
  기회를 잃어 기각.

## 결과

- index-worker는 Java·Spring 스택으로 message-queue를 소비한다.
- 임베딩·Reranker는 model-serving을 호출한다.
