---
document-id: standard-09-operations
role: standard
stage: "09"
status: drafted
owner: yhn032
updated: 2026-06-29
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

## 완료 기준

- 정상과 비정상 상태를 관측할 수 있다.
- 장애 원인 조사에 필요한 기록이 남는다.
- 반복 가능한 대응 절차와 책임 범위가 정의되어 있다.
