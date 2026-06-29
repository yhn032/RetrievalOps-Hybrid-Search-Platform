---
document-id: deliverable-adr-0008-search-availability
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-29
source: intake-side-project-charter
sensitivity: public
---

# ADR 0008 — 검색 경로 가용성·복원력

## 맥락

검색은 동기·저지연 읽기 경로이며 폭주·부분 장애에도 가용성을 지켜야 한다(NFR-2,
운영 목표). 메시지 큐는 비동기 색인용이고([ADR-0004](0004-message-queue.md)), 동기
검색 요청을 큐로 버퍼링하면 지연(p50/p95)이 커지고 멱등 읽기에는 "유실 방지"가 무의미해
부적합하다.

## 결정

검색 경로의 가용성은 큐가 아니라 다음으로 확보한다.

- api-service·retrieval-service를 무상태로 두고 복제 + 로드밸런서로 수평 확장
- OpenSearch 클러스터 레플리카로 검색 저장소 이중화
- Redis 캐시로 반복 질의 흡수 및 부분 degraded 응답
- 과부하 시 rate limit / admission control로 빠르게 부하 차단(429)
- 타임아웃·재시도·서킷브레이커로 의존 장애 격리

## 근거

- 동기 읽기는 "빠른 처리 또는 빠른 실패"가 맞고, 멱등이라 실패 시 재시도로 충분하다.
- 색인을 큐로 분리(ADR-0004)해 색인 부하가 검색 경로를 잠식하지 않게 한다(간접 보호).

## 대안

- 검색 요청을 메시지 큐로 버퍼링: 부하 평탄화·유실 방지 목표는 타당하나 동기 읽기에는
  지연 증가·무의미한 지연 응답으로 기각. 두 목표는 색인(쓰기) 경로에서 큐로 실현한다.

## 결과

- 복제·캐시·rate limit·서킷브레이커를 M4(성능·관측)에서 구성·측정한다.
- 메시지 큐(RabbitMQ)는 색인 경로에 한정한다.
