---
document-id: deliverable-adr-0002-opensearch
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-28
source: intake-side-project-charter
sensitivity: public
---

# ADR 0002 — 검색 저장소로 OpenSearch 사용

## 맥락

BM25(희소), Dense(벡터), 그리고 둘을 결합한 Hybrid 검색을 하나의 저장소에서
제공해야 한다(요구사항 FR-2·FR-3).

## 결정

검색 저장소로 OpenSearch를 사용한다. BM25 색인과 벡터 색인을 함께 두고
Hybrid 질의를 구성한다.

## 대안

- Elasticsearch: 기능은 유사하나 라이선스 제약이 있어 Apache-2.0 기반 OpenSearch를
  택함(재직 환경의 검색 색인 담당과도 구분됨).
- FAISS 단독: 벡터에 특화되어 BM25·운영 기능이 없어 기각.
- 관계형 DB 벡터 확장: BM25와 분리되어 Hybrid 구성이 복잡해 기각.

## 결과

- 단일 엔진으로 BM25·벡터·Hybrid를 모두 처리한다.
- `search-store` 인프라 컨테이너로 기동한다.
- 색인 스키마·분석기 설정은 M1에서 확정한다.
