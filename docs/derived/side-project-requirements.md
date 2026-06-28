---
document-id: derived-side-project-requirements
role: derived
stage: "01"
status: drafted
owner: yhn032
updated: 2026-06-28
source: intake-side-project-charter
sensitivity: public
---

# RAG Retrieval Platform 요구사항

원본 차터에서 추출한 요구사항을 기능·비기능으로 정리합니다. 출처와 배치
원칙은 [원본 분석과 배치표](side-project-source-analysis.md)를 따릅니다. 기술
버전·선택은 여기서 확정하지 않고 ADR(P3)에서 결정합니다.

## 목적

검색·RAG 역량과 일반 백엔드 운영 역량을 하나의 재현 가능한 서비스로 증명한다.
공개 데이터로 신규 구현하며 재직 데이터·코드를 사용하지 않는다.

## 기능 요구사항

| ID | 요구사항 | 근거 모듈/마일스톤 |
|---|---|---|
| FR-1 | 문서 검색 REST API(질의 입력, 결과·점수 반환) | api-service / M1 |
| FR-2 | BM25 색인·검색 | search-store / M1 |
| FR-3 | 임베딩 기반 Dense 검색과 BM25·Dense Hybrid 결합 | retrieval-service / M2 |
| FR-4 | Reranker 적용과 적용 전후 결과 비교 | retrieval-service / M2 |
| FR-5 | 비동기 수집→파싱→청킹→임베딩→색인 파이프라인 | index-worker / M3 |
| FR-6 | 작업 상태 조회 API, 실패 재시도, 중복 색인 방지 | api-service·index-worker / M3 |
| FR-7 | 검색 응답 캐시와 만료·무효화 정책 | cache / M3 |
| FR-8 | 문서·작업 메타데이터 저장과 조회 | metadata-store / M1·M3 |

## 비기능 요구사항

| ID | 요구사항 | 측정·수용 방식 |
|---|---|---|
| NFR-1 | 검색 품질을 기준선 대비 정량 평가 | Recall@k·MRR·nDCG, 평가셋 분리(누수 방지) |
| NFR-2 | 서버 성능 측정 | p50/p95 지연, QPS, 오류율, 워밍업·반복 횟수 기록 |
| NFR-3 | 색인 파이프라인 신뢰성 | 처리량·실패율 측정, 재처리 시 중복 색인 없음 |
| NFR-4 | 캐시 효과 검증 | 적중률 측정, 무효화 조건 테스트 |
| NFR-5 | 관측 가능성 | 로그·메트릭 대시보드, CI 구축 |
| NFR-6 | 재현성 | 새 환경에서 문서대로 1회 실행(컨테이너 원클릭) |
| NFR-7 | 자동 테스트 | 핵심 API·색인 파이프라인 단위·통합 테스트 통과 |
| NFR-8 | 보안 | 비밀값·고객 데이터 미포함, 공개 가능 저장소 |
| NFR-9 | 결과 투명성 | 목표 미달도 병목·다음 개선안과 함께 기록 |

## 제약과 가정

- 공개 데이터셋을 사용하고 정답셋을 별도로 정의한다.
- metadata DB, message queue, Kubernetes 등 기술 선택은 ADR에서 근거와 함께
  결정하며, 선택 이유를 설명하지 못하는 구성요소는 제거한다.
- 기술 개수를 늘리기 위해 모듈을 분할하지 않는다.
- 코드·컨테이너는 이 저장소에서 구현하며 별도 저장소를 만들지 않는다.

## 수용 게이트

이력서 반영 게이트(저장소 공개 가능·비밀값 없음, 신규 환경 실행, 핵심 자동
테스트 통과, 동일 조건 전후 비교, 주요 설계 결정·trade-off 기록, 결과 수치에
환경·데이터 크기·반복 횟수 명시)를 모두 충족할 때 사이드 프로젝트를 완료로 본다.
세부 측정 조건은 평가 계약(P2)에서 확정한다.
