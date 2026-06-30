---
document-id: standard-09-operations
role: standard
stage: "09"
status: approved
owner: yhn032
updated: 2026-06-30
source: internal
sensitivity: public
---

# 09 운영

## 목적

서비스 상태·로그·지표·장애 대응과 변경 이력을 관리한다.

## 적용 기준

- 각 서비스는 health check 엔드포인트와 구조화 로그를 제공한다.
- 핵심 지표를 관측한다: 지연 p50/p95, QPS, 오류율, 색인 처리량·실패율, 캐시 적중률
  ([평가 계약](../deliverables/evaluation-contract.md) M4 기준).
- 비동기 색인은 작업 상태·재시도·DLQ를 모니터링하고 중복 색인을 방지한다.
- 로그·메트릭 대시보드와 CI로 변경·상태를 추적한다(M4).
- 장애 대응 책임 범위는 코드 수정 단위·인프라 단위별 소유 경계를 따르며, 구현·대응은
  사용자가, 프레임워크·리뷰는 에이전트가 맡는다
  ([협업·개발 워크플로](../deliverables/collaboration-workflow.md)).
- 장애는 조사→대응→기록 순서로 처리하고, 대응·변경 이력을 CI·대시보드로 추적한다.

## 완료 기준

- 정상과 비정상 상태를 관측할 수 있다.
- 장애 원인 조사에 필요한 기록이 남는다.
- 반복 가능한 대응 절차와 책임 범위가 정의되어 있다.
