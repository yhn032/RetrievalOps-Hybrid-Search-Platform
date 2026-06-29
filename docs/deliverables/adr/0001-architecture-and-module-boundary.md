---
document-id: deliverable-adr-0001-architecture
role: deliverable
stage: "02"
status: drafted
owner: yhn032
updated: 2026-06-29
source: intake-side-project-charter
sensitivity: public
---

# ADR 0001 — 아키텍처와 모듈 경계

## 맥락

검색·RAG 역량과 백엔드 운영 역량을 하나의 재현 가능한 서비스로 증명해야 한다.
기술 개수를 늘리려고 모듈을 나누지 않으며, 선택 이유를 설명하지 못하는
구성요소는 제거한다.

## 결정

계층형 아키텍처를 채택한다.

```text
Client
  -> api-service (Spring Boot)
       -> cache (Redis)
       -> metadata-store (MariaDB)
       -> search-store (OpenSearch)
       -> retrieval-service (FastAPI) -> model-serving (임베딩·Reranker)
       -> message-queue (RabbitMQ) -> index-worker (Java)
index-worker: 수집 → 파싱 → 청킹 → 임베딩(model-serving 호출) → 색인
```

모듈 경계는 8개이며, 각 모듈이 하나의 컨테이너 배포 단위가 된다.

| 모듈 | 책임 | 배포 성격 |
|---|---|---|
| `api-service` | 검색 질의 처리·작업 상태 노출·캐시 정책 적용 | 코드 수정 단위 |
| `retrieval-service` | Dense·Hybrid 결합·검색 오케스트레이션 | 코드 수정 단위 |
| `model-serving` | 임베딩·Reranker 모델 추론([ADR-0007](0007-model-serving.md)) | 코드 수정 단위 |
| `index-worker` | 수집·청킹·재시도·색인(Java, [ADR-0006](0006-index-worker-language.md)) | 코드 수정 단위 |
| `search-store` | BM25·벡터·Hybrid 검색 | 인프라 컨테이너 |
| `metadata-store` | 문서·작업 메타데이터 | 인프라 컨테이너 |
| `cache` | 검색 응답 캐시·무효화 | 인프라 컨테이너 |
| `message-queue` | 색인 작업 큐·재시도·DLQ(RabbitMQ, [ADR-0004](0004-message-queue.md)) | 인프라 컨테이너 |

차터의 "별도 저장소"는 이력서 고도화 프로젝트에서 사이드 프로젝트를 분리한다는
의미이며, 이 워크스페이스가 바로 그 분리된 본체다(사용자 확정,
[원본 분석](../../derived/side-project-source-analysis.md) 참조). 따라서 코드·컨테이너를
모두 이 저장소에서 구현하고 추가 저장소는 만들지 않는다.

## 대안

- 단일 모놀리식: 모듈·배포 경계와 운영 역량을 보여주기 어려워 기각.
- 과도한 마이크로서비스 분할: 기술 과시용 분할은 차터 원칙에 반해 기각.

## 결과

- 코드 수정 단위 4종(api-service·retrieval-service·model-serving·index-worker)은 VS Code 로컬 디버깅을 지원한다.
- 인프라 단위 4종(search-store·metadata-store·cache·message-queue)은 컨테이너로만 기동한다.
- 세부 배포 단위 구성은 P5~P7에서 확정한다.
