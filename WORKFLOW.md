---
document-id: workflow-router
role: standard
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-28
source: internal
sensitivity: public
---

# 프로젝트 워크플로우

이 문서는 프로젝트 생애주기와 문서 위치를 안내하는 최상위 라우터입니다.

## 생애주기

```text
00 공통 → 01 수령 → 02 아키텍처
                       ├→ 03 UI ─┐
                       └→ 04 API ┴→ 05 코딩 → 06 테스트 → 07 보안 → 08 배포 → 09 운영
```

- `00 공통`은 모든 단계에 적용합니다.
- `03 UI`와 같은 조건부 단계는 적용 여부를 결정하기 전까지 `template` 상태를 유지합니다.
- 사용하지 않는 단계는 `excluded`로 바꾸고 [MANIFEST](docs/standards/MANIFEST.md)에 사유를 기록합니다.
- 선행 단계가 `approved` 또는 사유가 있는 `excluded` 상태일 때만 다음 단계에 진입합니다.

단계별 적용 여부와 상태는 [MANIFEST](docs/standards/MANIFEST.md)에서 확인합니다.

## 문서 배치

| 문서 성격 | 경로 | Git 정책 |
|---|---|---|
| 표준과 상태 | [`docs/standards/`](docs/standards/README.md) | 추적 |
| 전달받은 원본 | [`docs/intake/`](docs/intake/README.md) | README만 추적 |
| 벤더·오픈소스 원본 | [`docs/origin/`](docs/origin/README.md) | README만 추적 |
| 내부·민감 자료 | [`docs/internal/`](docs/internal/README.md) | README만 추적 |
| 미분류 자료 | [`docs/inbox/`](docs/inbox/README.md) | README만 추적 |
| 프로젝트 산출물 | [`docs/deliverables/`](docs/deliverables/README.md) | 추적 |
| 원본 기반 분석 | [`docs/derived/`](docs/derived/README.md) | 추적 |
| 외부 공개 자료 조사 | [`docs/research/`](docs/research/README.md) | 추적 |

문서 전체 지도는 [docs/README.md](docs/README.md)를 기준으로 합니다.

## 프로젝트 진입점

- [README.md](README.md): 프로젝트 소개와 시작 방법
- [PROJECT.md](PROJECT.md): 프로젝트 목표와 도메인
- [REFERENCE.md](REFERENCE.md): 실행 명령과 운영 절차
- [AGENTS.md](AGENTS.md): Codex 거버넌스
- [CLAUDE.md](CLAUDE.md): Claude 거버넌스
- [app/README.md](app/README.md): 애플리케이션 배포 단위
- [다음 WIP](wip/task-20260628-side-project-expansion/README.md): 사이드 프로젝트 문서 이식 및 컨테이너 분리 (대기 중)

## 설계·협업

- [시스템 설계](docs/deliverables/system-design.md): 컨테이너 책임·인터페이스·데이터·흐름
- [WBS](docs/deliverables/wbs.md): 마일스톤별 작업 분해와 담당
- [협업·개발 워크플로](docs/deliverables/collaboration-workflow.md): 에이전트는 프레임워크·리뷰, 사용자가 코드·테스트

## 현재 범위

현재 단계는 RAG Retrieval Platform의 설계·평가 계약·ADR과 컨테이너 프레임워크입니다. 제품 코드와 테스트는 [협업 워크플로](docs/deliverables/collaboration-workflow.md)에 따라 사용자가 구현하고 에이전트가 리뷰합니다.

## 자동 검사

기존 completion checker가 다음 검사를 함께 실행합니다.

- [workflow-gate.sh](scripts/meta/workflow-gate.sh): 문서 배치, 메타데이터, 상태, 출처, 민감 경로와 기준본 변경
- [docs-link-check.sh](scripts/meta/docs-link-check.sh): 깨진 링크와 `WORKFLOW.md`에서 도달할 수 없는 문서
- [workflow-gate-test.sh](scripts/meta/workflow-gate-test.sh): 정상 fixture와 의도적인 위반 fixture

commit gate는 staged 변경을 매번 검사하며, 기준본 변경은 커밋 본문의 `Rebaseline:` 사유가 있어야 허용합니다.
