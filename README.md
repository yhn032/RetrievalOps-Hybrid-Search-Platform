# RAG Retrieval Platform

검색·RAG 역량과 백엔드 운영 역량을 하나의 재현 가능한 서비스로 증명하는 포트폴리오
사이드 프로젝트입니다. 재직 데이터·코드를 사용하지 않고 공개 데이터로 신규 구현합니다.

이 저장소가 프로젝트 본체이며, claude·codex 폴리에이전트 오케스트레이션 환경 위에서
개발합니다. 문서·생애주기 라우터는 [WORKFLOW.md](WORKFLOW.md)를 기준으로 합니다.

## 아키텍처

```text
Client
  -> api-service (Spring Boot)
       -> cache (Redis)
       -> metadata-store (MariaDB)
       -> search-store (OpenSearch: BM25·벡터·Hybrid)
       -> retrieval-service (FastAPI 임베딩/Reranker)
  -> index-worker: 수집 → 파싱 → 청킹 → 임베딩 → 색인
```

모듈 경계와 선택 근거는 [ADR](docs/deliverables/adr/README.md)에 기록되어 있습니다.

## 마일스톤

| 단계 | 내용 |
|---|---|
| M0 | 범위·평가 계약·아키텍처 결정 |
| M1 | Spring Boot 검색 API + OpenSearch BM25 기준선 |
| M2 | Dense·Hybrid·Reranker와 검색 품질 평가 |
| M3 | 비동기 색인 파이프라인·캐시·작업 상태 |
| M4 | 성능·관측·배포 측정 |
| M5 | 공개 포트폴리오 정리 |

## 문서

- [프로젝트 가이드](docs/deliverables/project-guide.md) — 전체 그림과 길잡이(여기부터)
- [요구사항](docs/derived/side-project-requirements.md)
- [평가 계약 (M0·M2·M4)](docs/deliverables/evaluation-contract.md)
- [아키텍처 결정 기록 (ADR)](docs/deliverables/adr/README.md)
- [실행·운영 절차](REFERENCE.md)

## 현재 상태

M0 문서 단계(범위·요구사항·평가 계약·ADR)를 작성했습니다. 기능별 컨테이너 배포
단위와 실제 구현은 후속 단계에서 진행합니다. 진행 상황은 [WORKFLOW.md](WORKFLOW.md)와
`wip/`를 참조하세요.

## 개발 환경

claude·codex 두 에이전트가 동일 저장소를 패리티로 운영하는 DevContainer에서
개발합니다. 컨테이너·에이전트·검증 게이트 명령은 [REFERENCE.md](REFERENCE.md)를
참조하세요. 이 컨테이너는 워크스페이스 경계이지 보안 샌드박스가 아닙니다
([REFERENCE.md 권한 경계](REFERENCE.md#privilege-boundary)).
