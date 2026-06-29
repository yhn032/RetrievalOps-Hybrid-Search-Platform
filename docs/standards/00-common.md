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

## 완료 기준

- 모든 프로젝트 문서가 역할에 맞는 경로에 있고 링크가 끊기지 않는다.
- 변경 상태와 실제 문서 내용이 일치한다.
- 현재 작업과 미해결 gap을 WIP에서 확인할 수 있다.
