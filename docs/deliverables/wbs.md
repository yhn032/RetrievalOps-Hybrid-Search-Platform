---
document-id: deliverable-wbs
role: deliverable
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-29
source: intake-side-project-charter
sensitivity: public
---

# WBS (작업 분해 구조)

마일스톤별 작업을 배포 단위 기준으로 분해한다. 담당 표기는
[협업 워크플로](collaboration-workflow.md)를 따른다. 설계 기준은
[시스템 설계](system-design.md), 측정 기준은 [평가 계약](evaluation-contract.md)이다.

담당 범례: **F** 에이전트 프레임워크·스캐폴드 · **D** 에이전트 설계·문서 ·
**C** 사용자 코드+테스트 구현 · **R** 에이전트 리뷰.

대상 배포 단위(9): web-ui, api-service, retrieval-service, model-serving, index-worker(Java),
search-store, metadata-store, cache, message-queue(RabbitMQ).

## M0 — 범위·설계

| ID | 작업 | 담당 | 상태 |
|---|---|---|---|
| 0.1 | 요구사항·평가계약·ADR 0001~0006 | D | 완료 |
| 0.2 | 협업 워크플로·WBS·시스템 설계 | D | 진행 |
| 0.3 | 데이터셋·질의셋 선정 ADR(0007) | D | 대기 |
| 0.4 | 결정 반영 스캐폴드: model-serving·message-queue 단위 추가, index-worker Java 전환, ADR-0004/0006 갱신 | F | 대기 |

## M1 — 검색 기준선

| ID | 작업 | 담당 | 의존 |
|---|---|---|---|
| 1.1 | api-service: 검색 API 골격(컨트롤러·DTO·계약) | F | 0.4 |
| 1.1c | api-service: 검색 API 구현 + 테스트 | C | 1.1 |
| 1.2 | search-store: BM25 색인 스키마·분석기 설계 | D/F | — |
| 1.2c | 색인·BM25 검색 구현 + 테스트 | C | 1.2 |
| 1.3 | metadata-store: 스키마(문서·작업) 설계 | D/F | — |
| 1.3c | JPA 연동·저장 구현 + 테스트 | C | 1.3 |
| 1.4 | 통합 흐름(API→OpenSearch→DB) 리뷰 | R | 1.1c·1.2c·1.3c |

## M2 — RAG Retrieval

| ID | 작업 | 담당 | 의존 |
|---|---|---|---|
| 2.1 | model-serving: 임베딩·Reranker API 계약 골격 | F | 0.4 |
| 2.1c | 임베딩·Reranker 구현 + 테스트 | C | 2.1 |
| 2.2 | retrieval-service: Dense·Hybrid 결합 골격(model-serving 호출) | F | 2.1 |
| 2.2c | Dense·Hybrid·Reranker 적용 구현 + 테스트 | C | 2.2 |
| 2.3 | 평가 하니스 골격(Recall@k·MRR·nDCG, 평가셋 분리) | F | — |
| 2.3c | 평가 실행·결과표 작성 | C | 2.3·1.x |

## M3 — 운영형 백엔드

| ID | 작업 | 담당 | 의존 |
|---|---|---|---|
| 3.1 | message-queue: RabbitMQ 큐·토픽·재시도 정책 설계 | D/F | 0.4 |
| 3.2 | index-worker(Java): 수집→파싱→청킹→임베딩(호출)→색인 골격, 재시도·중복방지 | F | 2.1·3.1 |
| 3.2c | 색인 파이프라인 구현 + 테스트 | C | 3.2 |
| 3.3 | cache: 캐시 키·만료·무효화 정책 설계 | D/F | — |
| 3.3c | 캐시·무효화 구현 + 테스트 | C | 3.3 |
| 3.4 | 작업 상태 API 골격 | F | 3.1 |
| 3.4c | 작업 상태·재시도 API 구현 + 테스트 | C | 3.4 |

## M4 — 성능·관측·배포

| ID | 작업 | 담당 | 의존 |
|---|---|---|---|
| 4.1 | 부하 테스트(k6) 골격·시나리오 | F | M3 |
| 4.1c | 부하 측정·결과 기록(p50/p95·QPS·오류율) | C | 4.1 |
| 4.2 | 로그·메트릭·대시보드 골격 | F | M3 |
| 4.2c | 관측 구현 + 검증 | C | 4.2 |
| 4.3 | CI 파이프라인 골격 | F | M1 |
| 4.3c | CI 구성·통과 | C | 4.3 |

## M5 — 공개 포트폴리오

| ID | 작업 | 담당 | 의존 |
|---|---|---|---|
| 5.1 | 설계·시퀀스·API 명세 정리 | D | M1~M4 |
| 5.2 | 결과 비교표·회고 작성 | C/D | M4 |

## 진행 규칙

- 각 `*c`(구현) 항목은 협업 워크플로의 피드백 루프 1회 단위다: F/D 산출 → C 구현 → R 리뷰 → 수정 반복.
- 상태는 이 표에서 갱신한다. 컨테이너 런타임 규칙은 `runtime-rules-check.sh`로 검증한다.
