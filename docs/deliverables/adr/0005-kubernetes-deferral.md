---
document-id: deliverable-adr-0005-kubernetes
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-28
source: intake-side-project-charter
sensitivity: public
---

# ADR 0005 — Kubernetes 적용 시점

## 맥락

차터는 Kubernetes 배포를 로컬 운영형 완성 후 선택 적용한다고 명시한다(M4).
재현성 요구(NFR-6)는 원클릭 실행을 요구한다.

## 결정

로컬 운영형은 Docker Compose로 구성하고, Kubernetes는 로컬 운영형이 완성된
뒤 선택적으로 적용한다.

## 근거

- 재현성·원클릭 실행 목표는 Compose로 충족한다.
- K8s를 선제 도입하면 복잡도가 증가하고 차터의 단계 원칙에 어긋난다.

## 대안

- 초기부터 Kubernetes: 로컬 재현·디버깅 부담이 커 기각(차터가 후순위로 둠).

## 결과

- dev·stg·prod 구성은 Compose 기반으로 P6에서 정의한다.
- K8s 매니페스트는 M4 이후 선택 산출물로 남긴다.
