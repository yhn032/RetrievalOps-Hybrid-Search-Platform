---
document-id: deliverable-adr-0006-index-worker-language
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-28
source: intake-side-project-charter
sensitivity: public
---

# ADR 0006 — 색인 워커 구현 언어

## 맥락

색인 워커는 수집→파싱→청킹→임베딩→색인을 수행한다(FR-5). 차터는 구현 언어를
Python 또는 Java 중 M0에서 결정하도록 했다.

## 결정

색인 워커를 Python으로 구현한다.

## 근거

- 임베딩·청킹·문서 파싱 생태계가 Python 중심이며 retrieval-service(FastAPI)와
  의존성을 공유할 수 있다.
- 임베딩 단계를 Java로 옮기면 임베딩 스택이 중복된다.

## 대안

- Java 구현: Spring 비동기·재시도 역량을 함께 보여줄 수 있으나, 임베딩 의존성
  중복으로 기각. Java 비동기 시연을 우선한다면 재검토할 수 있는 잠정 결정이다.

## 결과

- index-worker는 retrieval-service와 Python 의존성을 공유한다.
- api-service는 Java로 유지한다.
- 이 결정은 잠정이며 포트폴리오 강조점에 따라 재검토할 수 있다.
