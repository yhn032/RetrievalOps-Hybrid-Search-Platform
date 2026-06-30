---
document-id: standard-05-coding
role: standard
stage: "05"
status: approved
owner: yhn032
updated: 2026-06-30
source: internal
sensitivity: public
---

# 05 코딩

## 목적

설계를 구현할 때 적용할 코드 구성, 변경 단위와 품질 기준을 정의한다.

## 적용 기준

- 제품 코드와 테스트는 사용자가 작성하고, 에이전트는 골격·리뷰만 제공한다
  ([협업·개발 워크플로](../deliverables/collaboration-workflow.md)).
- 언어별 구조는 [시스템 설계](../deliverables/system-design.md)의 구현 골격을 따른다:
  api-service는 `controller→service→repository→client`, FastAPI 단위는 `router→service→client`,
  index-worker(Java)는 `consumer→pipeline→client`.
- 설정은 환경변수로 주입하고 비밀값은 코드·추적 파일에 두지 않는다.
- 변경은 리뷰 가능한 작은 단위(WBS 항목)로 나눈다. 과한 추상화·중복은 피한다.
- 빌드·정적 검사(lint·type)는 배포 단위별 표준 도구로 동일 명령으로 재현한다.

## 완료 기준

- 구현이 승인된 설계·ADR과 연결된다.
- 비밀정보가 코드와 추적 파일에 포함되지 않는다.
- 빌드와 정적 검사가 재현 가능하다.
