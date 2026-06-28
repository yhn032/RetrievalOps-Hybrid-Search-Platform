---
document-id: deliverable-adr-0003-metadata-db
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-28
source: intake-side-project-charter
sensitivity: public
---

# ADR 0003 — 메타데이터 DB 선택

## 맥락

문서·작업 메타데이터와 작업 상태를 저장할 관계형 DB가 필요하다(FR-8). 벡터는
OpenSearch에 두므로 DB는 일반 관계형 기능만 요구한다.

## 결정

메타데이터 DB로 MySQL/MariaDB를 사용한다.

## 근거

- 메타데이터·작업 상태는 표준 관계형 모델로 충분하며 PostgreSQL 고유 기능이
  필요하지 않다(벡터는 OpenSearch가 담당).
- 이력서 전략상 PostgreSQL은 실무 스킬에서 제외하고, MariaDB는 실무 근거 확인
  대상 스택으로 사이드 프로젝트에서 근거를 보강한다.
- 기존 Java·Spring Data JPA·QueryDSL 경험과 정합한다.

## 대안

- PostgreSQL: 위 근거로 기각(고유 기능 불요, 이력서 전략상 비강조).
- 문서형 NoSQL: 작업 상태·조인 처리가 관계형이 단순해 기각.

## 결과

- `metadata-store` 인프라 컨테이너로 MariaDB를 기동한다.
- api-service는 JPA/QueryDSL로 연동한다.
- 스키마 상세는 M1에서 확정한다.
