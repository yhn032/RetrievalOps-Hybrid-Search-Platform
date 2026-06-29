---
document-id: standard-02-architecture
role: standard
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-29
source: internal
sensitivity: public
---

# 02 아키텍처

## 목적

시스템 경계·구성요소·데이터 흐름과 주요 기술 결정을 정의하고 근거를 남긴다.

## 적용 기준

- 시스템 구조와 컨테이너 책임·인터페이스·데이터 흐름은
  [시스템 설계](../deliverables/system-design.md)로 관리한다.
- 모든 주요 기술 결정은 [ADR](../deliverables/adr/README.md)에 맥락·결정·대안·결과로
  기록한다. 기술 개수를 늘리려고 모듈을 나누지 않으며, 설명할 수 없는 구성요소는 제거한다.
- 배포 단위는 `app/<deployment-unit>/`이며 기능 경계와 컨테이너 단위를 일치시킨다.
- 보안·배포·운영에 영향을 주는 경계는 식별해 후속 단계(07·08·09)로 넘긴다.

## 완료 기준

- 구현 단위와 책임이 구분되어 있다(9개 배포 단위).
- 주요 결정의 근거와 보류 사항이 ADR로 기록되어 있다.
- 보안·배포·운영에 영향을 주는 경계가 식별되어 있다.
