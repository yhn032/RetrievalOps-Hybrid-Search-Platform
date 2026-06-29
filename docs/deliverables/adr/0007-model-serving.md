---
document-id: deliverable-adr-0007-model-serving
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-29
source: intake-side-project-charter
sensitivity: public
---

# ADR 0007 — 모델 서빙 분리

## 맥락

원본 차터·요구사항은 검색 엔진·DB와 더불어 모델도 별도 컨테이너로 기동할 것을
요구한다. 초기 설계([ADR-0001](0001-architecture-and-module-boundary.md))는 임베딩·
Reranker를 retrieval-service에 in-process로 두어 별도 모델 단위가 없었다.

## 결정

임베딩·Reranker 모델 추론을 `model-serving`이라는 별도 배포 단위(FastAPI)로 분리한다.
retrieval-service는 검색 오케스트레이션을 맡고, 임베딩·Reranker는 model-serving을
REST로 호출한다.

## 근거

- 차터의 "모델도 별도 컨테이너" 요구를 충족하고, 모델 서빙(GPU·vLLM 등) 운영을
  포트폴리오로 노출한다.
- 검색 로직과 모델 런타임의 자원·배포 특성을 분리해 독립적으로 확장·교체할 수 있다.

## 대안

- retrieval-service in-process 유지: 단순하지만 차터 요구와 어긋나고 모델 서빙
  역량을 드러내지 못해 기각.

## 결과

- `model-serving`을 코드 수정 단위로 추가한다(배포 단위 8개로 증가).
- retrieval-service·index-worker는 임베딩·Reranker를 REST로 호출한다.
- 모델·런타임 선택은 M2에서 확정한다.
