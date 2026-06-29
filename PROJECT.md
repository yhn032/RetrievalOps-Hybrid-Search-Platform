# PROJECT.md — RAG Retrieval Platform

> 검색·RAG 백엔드 포트폴리오 사이드 프로젝트.
> 거버넌스: [CLAUDE.md](CLAUDE.md) (Claude) · [AGENTS.md](AGENTS.md) (Codex)
> 라우터: [WORKFLOW.md](WORKFLOW.md) · 명령: [REFERENCE.md](REFERENCE.md)

## 개요

공개 데이터로 BM25·Dense·Hybrid 검색과 RAG retrieval을 구현하고, 비동기 색인
파이프라인·캐시·관측까지 갖춘 재현 가능한 백엔드 서비스를 만든다. 재직 데이터·
코드는 사용하지 않으며, 검색 품질과 서버 성능을 동일 조건에서 정량 비교한다.

상세 목적·요구사항은 [요구사항 문서](docs/derived/side-project-requirements.md),
측정 기준은 [평가 계약](docs/deliverables/evaluation-contract.md)을 따른다.

## 목표 (마일스톤)

| 단계 | 목표 | 완료 신호 |
|---|---|---|
| M0 | 범위·평가 계약·ADR | 데이터셋·질의셋·아키텍처 결정 |
| M1 | 검색 기준선 | Spring API + OpenSearch BM25 + 메타데이터 저장 |
| M2 | RAG retrieval | Dense·Hybrid·Reranker, Recall@k·MRR·nDCG 비교 |
| M3 | 운영형 백엔드 | 비동기 색인·캐시 무효화·재시도·작업 상태 API |
| M4 | 성능·관측·배포 | p50/p95·QPS·오류율·처리량, 대시보드·CI |
| M5 | 공개 포트폴리오 | 설계·결과·회고 정리 |

## 기술 스택 (ADR 결정)

| 모듈 | 기술 | 근거 |
|---|---|---|
| api-service | Java · Spring Boot | [ADR-0001](docs/deliverables/adr/0001-architecture-and-module-boundary.md) |
| retrieval-service · index-worker | Python · FastAPI | [ADR-0006](docs/deliverables/adr/0006-index-worker-language.md) |
| search-store | OpenSearch | [ADR-0002](docs/deliverables/adr/0002-use-opensearch.md) |
| metadata-store | MariaDB | [ADR-0003](docs/deliverables/adr/0003-select-metadata-db.md) |
| cache | Redis | [ADR-0001](docs/deliverables/adr/0001-architecture-and-module-boundary.md) |
| 비동기 작업 | DB 작업 테이블 (→ RabbitMQ 업그레이드) | [ADR-0004](docs/deliverables/adr/0004-message-queue.md) |
| 배포 | Docker Compose (→ Kubernetes 선택) | [ADR-0005](docs/deliverables/adr/0005-kubernetes-deferral.md) |

## 컨테이너 경계

`app/<deployment-unit>/`가 컨테이너 배포 단위다. 코드 수정 단위(api-service·
retrieval-service·index-worker)는 VS Code 로컬 디버깅을 지원하고, 인프라 단위
(search-store·metadata-store·cache)는 컨테이너로만 기동한다. 세부 구성은 후속
단계에서 확정한다.

## 개발·오케스트레이션 환경

claude·codex 두 에이전트가 동일 저장소를 패리티로 운영한다. `.claude/`가 거버넌스
기준이고 `.agents/`·`.codex/`는 미러다. `.vscode/`는 에디터 편의 설정으로
추적하며 에이전트 벤더가 아니다. 컨테이너·검증 명령은
[REFERENCE.md](REFERENCE.md)를 따른다.

## 협업 모델

에이전트는 프레임워크·설계·WBS·리뷰를 담당하고, 제품 코드와 테스트는 사용자가
구현한다. 세부 규칙은 [협업·개발 워크플로](docs/deliverables/collaboration-workflow.md),
작업 분해는 [WBS](docs/deliverables/wbs.md), 설계는
[시스템 설계](docs/deliverables/system-design.md)를 따른다.
