---
document-id: standard-04-api
role: standard
stage: "04"
status: drafted
owner: yhn032
updated: 2026-06-29
source: internal
sensitivity: public
---

# 04 API

## 목적

서비스 간·외부 API의 계약, 형식, 오류 처리, 버전 관리 기준을 정의한다.

## 적용 기준

- 엔드포인트·요청/응답 계약은 [시스템 설계](../deliverables/system-design.md)의
  인터페이스 계약을 기준으로 하고, 구현 시 OpenAPI/스키마로 확정한다.
- REST를 기본으로 하며 요청·응답은 JSON, 인코딩은 UTF-8로 통일한다.
- 오류는 일관된 형식(코드·메시지·상세)과 적절한 HTTP 상태 코드로 반환한다.
- 검색 API는 `mode`(bm25·dense·hybrid)와 `k`를 받고 결과·점수·소요시간을 반환한다.
- 비호환 변경은 버전으로 분리하고, 비동기 작업 API는 작업 ID와 상태 조회를 제공한다.

## 완료 기준

- 각 서비스의 공개 엔드포인트와 요청/응답 계약이 정의되어 있다.
- 오류 형식·상태 코드 규칙이 일관된다.
- 계약이 시스템 설계·요구사항(FR-1·FR-6)과 연결된다.
