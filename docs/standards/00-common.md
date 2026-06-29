---
document-id: standard-00-common
role: standard
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-29
source: internal
sensitivity: public
---

# 00 공통

## 목적

프로젝트 전체에 적용할 변경 관리·검토·문서 연결·상태 관리 기준을 정의한다.
모든 후속 단계(01~09)는 이 기준 위에서 진행한다.

## 적용 기준

- 문서는 역할별 경로(`docs/`)에 배치하고 [WORKFLOW.md](../../WORKFLOW.md)에서 도달
  가능해야 한다. 관리 대상 문서는 [메타데이터 규격](document-metadata.md)을 따른다.
- 단계 상태는 [MANIFEST.md](MANIFEST.md)로 관리하며, 문서 status와 항상 일치시킨다.
- 진행과 미해결 gap은 WIP 문서로 추적한다.
- 개발 협업은 [협업·개발 워크플로](../deliverables/collaboration-workflow.md)를 따른다:
  에이전트는 프레임워크·설계·리뷰, 사용자는 모든 코드·테스트.
- 변경 검토·자동 검사는 `scripts/meta/`의 게이트(문서·링크·런타임)를 통과해야 한다.

## 커밋 규율

- 한 커밋은 하나의 관심사만 담는다. 되돌릴 때 하나의 end-state만 바뀌어야 하며,
  세부 기준은 [commit-discipline](../../.claude/rules/commit-discipline.md)을 따른다.
- 제목은 한국어로 큰 주제를, 본문에 세부 내용을 적는다(기술 용어는 영어 허용).
- 에이전트가 작성했다는 표기는 커밋에 남기지 않는다.
- 여러 변경을 한 커밋에 묶을 때는 본문에 `Coupling:` 사유를 적는다.
- 기준본(`docs/standards/_baseline/`)을 바꾸는 커밋은 본문에 `Rebaseline: <사유>`를 적는다.

## 브랜치 규약

표준 GitHub Flow를 따른다.

- `main`은 항상 배포 가능한 green 상태를 유지하며 직접 커밋하지 않는다.
- 모든 변경은 `main`에서 분기한 짧은 수명의 작업 브랜치에서 진행한다:
  기능 `feat/<주제>`, 수정 `fix/<주제>`, 문서 `docs/<주제>`.
- 작업 브랜치를 푸시하고 Pull Request를 연다. 코드는 사용자 구현 후 에이전트
  리뷰를, 문서는 검토를 거쳐 `main`에 병합한다.
- 병합은 squash를 기본으로 하고, 병합 후 작업 브랜치는 삭제한다.
- 병합 전 문서·링크·런타임 게이트와 (코드의 경우) 테스트가 통과해야 한다.

## 완료 기준

- 모든 프로젝트 문서가 역할에 맞는 경로에 있고 링크가 끊기지 않는다.
- 변경 상태와 실제 문서 내용이 일치한다.
- 커밋·브랜치 규약을 따르고 게이트를 통과한다.
- 현재 작업과 미해결 gap을 WIP에서 확인할 수 있다.
