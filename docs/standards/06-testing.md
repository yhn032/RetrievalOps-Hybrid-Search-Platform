---
document-id: standard-06-testing
role: standard
stage: "06"
status: drafted
owner: yhn032
updated: 2026-06-29
source: internal
sensitivity: public
---

# 06 테스트

## 목적

기능·통합·회귀와 검색 품질을 검증할 기준을 정의한다.

## 적용 기준

- 테스트 코드는 사용자가 작성하고 에이전트가 리뷰한다.
- 핵심 API와 색인 파이프라인에는 단위·통합 테스트를 둔다(요구사항 NFR-7).
- 검색 품질은 [평가 계약](../deliverables/evaluation-contract.md)의 지표
  (Recall@k·MRR·nDCG)로 측정하고, 평가셋을 분리해 데이터 누수를 막는다.
- 실패·경계 조건을 포함하고, 결과는 동일 명령으로 재현 가능해야 한다.

## 완료 기준

- 성공 조건이 측정 가능한 값으로 정의되어 있다.
- 실패와 경계 조건이 검증된다.
- 동일 명령으로 검증 결과를 재현할 수 있다.
