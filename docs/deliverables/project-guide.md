---
document-id: deliverable-project-guide
role: deliverable
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-29
source: internal
sensitivity: public
---

# 프로젝트 가이드

이 프로젝트의 전체 그림을 한 곳에서 파악하고 올바른 문서로 이동하기 위한 종합
안내서다. 세부 내용은 각 전용 문서를 가리키며, 여기서는 맥락과 길잡이만 제공한다.

## 한 줄 정의

공개 데이터로 BM25·Dense·Hybrid 검색과 RAG retrieval을 구현하고, 비동기 색인·
캐시·관측까지 갖춘 재현 가능한 백엔드 서비스. 검색 품질과 서버 성능을 동일 조건에서
정량 비교하는 포트폴리오 사이드 프로젝트다. 배경·목표는 [PROJECT.md](../../PROJECT.md).

## 아키텍처 한눈에

8개 배포 단위가 각각 컨테이너로 기동한다(근거: [ADR](adr/README.md)).

| 구분 | 단위 | 기술 |
|---|---|---|
| 코드 수정 단위 | api-service | Java · Spring Boot |
| | retrieval-service | Python · FastAPI |
| | model-serving | Python · FastAPI (임베딩·Reranker) |
| | index-worker | Java (비동기 색인) |
| 인프라 단위 | search-store | OpenSearch |
| | metadata-store | MariaDB |
| | cache | Redis |
| | message-queue | RabbitMQ |

책임·인터페이스 계약·데이터 모델·흐름은 [시스템 설계](system-design.md)에 있다.

## 마일스톤과 현황

| 단계 | 목표 | 현황 |
|---|---|---|
| M0 | 범위·평가 계약·ADR·설계 | 문서 완료, 데이터셋 ADR·스캐폴드 일부 잔여 |
| M1 | 검색 기준선(Spring API + OpenSearch BM25) | 예정 |
| M2 | Dense·Hybrid·Reranker + 품질 평가 | 예정 |
| M3 | 비동기 색인·캐시·작업 상태 | 예정 |
| M4 | 성능·관측·배포 측정 | 예정 |
| M5 | 공개 포트폴리오 정리 | 예정 |

세부 작업과 담당은 [WBS](wbs.md), 진행·gap은
[WIP](../../wip/task-20260628-side-project-expansion/README.md).

## 개발·협업 방식

에이전트는 **프레임워크·설계·WBS·리뷰**만 맡고, **모든 제품 코드와 테스트는 사용자**가
구현한다. 사용자가 구현하면 에이전트가 리뷰로 품질을 끌어올리는 반복 루프로 진행한다.
규칙 전문은 [협업·개발 워크플로](collaboration-workflow.md).

## 문서 지도 (무엇을 볼 때 어디로)

| 알고 싶은 것 | 문서 |
|---|---|
| 무엇을 만드는가 / 요구사항 | [요구사항](../derived/side-project-requirements.md) |
| 무엇을 어떻게 측정하는가 | [평가 계약](evaluation-contract.md) |
| 왜 이 기술·구조인가 | [ADR](adr/README.md) |
| 어떻게 설계됐는가(계약·흐름) | [시스템 설계](system-design.md) |
| 무슨 작업이 남았는가 | [WBS](wbs.md) |
| 어떻게 함께 일하는가 | [협업 워크플로](collaboration-workflow.md) |
| 컨테이너 런타임·배포 규칙 | [런타임·배포](runtime-and-deployment.md) |
| 실행·운영 명령 | [REFERENCE.md](../../REFERENCE.md) |
| 문서·생애주기 라우터 | [WORKFLOW.md](../../WORKFLOW.md) |
| 원본 분석·출처 | [원본 분석](../derived/side-project-source-analysis.md) |

## 처음 본다면 읽는 순서

1. [PROJECT.md](../../PROJECT.md) — 목표와 도메인
2. 이 가이드 — 전체 그림과 길잡이
3. [요구사항](../derived/side-project-requirements.md) → [시스템 설계](system-design.md) — 무엇을·어떻게
4. [ADR](adr/README.md) — 결정의 이유
5. [WBS](wbs.md) + [협업 워크플로](collaboration-workflow.md) — 무엇을 누가 어떻게

## 규약 요약

- 컨테이너는 비루트·호스트 UID/GID(코드 단위)·`TZ=UTC`·UTF-8을 지킨다([런타임·배포](runtime-and-deployment.md), `scripts/meta/runtime-rules-check.sh`).
- 비밀값은 추적하지 않는다(`.env`는 무시, `.env.example`만 추적).
- 추적 문서는 메타데이터·링크 게이트(`scripts/meta/`)를 통과해야 한다.
- 코드 수정 단위는 VS Code 로컬 디버깅, 배포는 별도 이미지로 분리한다.
