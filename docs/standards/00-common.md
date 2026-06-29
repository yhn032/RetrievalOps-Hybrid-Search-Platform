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

표준 Git Flow를 따른다.

- `main`: 배포(운영) 브랜치. 항상 배포 가능한 상태를 유지하고 릴리스마다 태그를 단다.
- `develop`: 통합 브랜치. 다음 릴리스를 향한 최신 개발 상태를 모은다.
- `feature/<주제>`: `develop`에서 분기해 기능을 개발하고 완료 후 `develop`으로 병합한다.
- `release/<버전>`: `develop`에서 분기해 릴리스를 준비(버그픽스·메타 정리)하고, 완료 시
  `main`과 `develop`에 병합하며 `main`에 버전 태그를 단다.
- `hotfix/<주제>`: `main`에서 분기해 긴급 수정 후 `main`과 `develop`에 병합하고 태그를 단다.
- 모든 병합은 PR로 리뷰를 거친다(코드는 사용자 구현 후 에이전트 리뷰). 병합 전
  문서·링크·런타임 게이트와 (코드의 경우) 테스트가 통과해야 한다.
- `develop` 브랜치는 코드 작업 착수 시 `main`에서 생성한다(현재는 문서 단계).

## 완료 기준

- 모든 프로젝트 문서가 역할에 맞는 경로에 있고 링크가 끊기지 않는다.
- 변경 상태와 실제 문서 내용이 일치한다.
- 커밋·브랜치 규약을 따르고 게이트를 통과한다.
- 현재 작업과 미해결 gap을 WIP에서 확인할 수 있다.
