---
document-id: derived-folder-governance-analysis
role: derived
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-28
source: intake-folder-governance-20260619
sensitivity: public
---

# 폴더 관리 체계 분석

## 분석 범위

사용자가 제공한 사업 프로젝트 문서·디자인 관리 체계 설계안 중 문서·폴더 관리 부분만 분석했습니다. 멀티 디자인 시스템과 화면 구현 구조는 범위에서 제외했습니다.

원본은 `docs/intake/`에 보관하며 Git에서 추적하지 않습니다. 이 문서는 공개 가능한 관리 원칙과 현재 저장소에 적용한 결과만 기록합니다.

## 적용한 원칙

| 원본 원칙 | 현재 적용 |
|---|---|
| 최상위 라우터와 생애주기 DAG | [WORKFLOW.md](../../WORKFLOW.md) |
| `00`부터 `09`까지의 단계 구분 | [단계별 표준](../standards/README.md) |
| 단계별 적용·승인 상태 | [MANIFEST.md](../standards/MANIFEST.md) |
| 역할과 Git 신뢰 수준에 따른 문서 배치 | [문서 지도](../README.md)와 `.gitignore` |
| 승인 기준본 분리 | [기준본 관리 절차](../standards/baseline-policy.md) |
| 필수 메타데이터와 출처 | [문서 메타데이터 규격](../standards/document-metadata.md) |
| 문서 규칙 자동 강제 | `scripts/meta/workflow-gate.sh` |
| 링크되지 않은 문서 차단 | `scripts/meta/docs-link-check.sh` |

## 프로젝트에 맞춘 조정

| 조정 | 이유 |
|---|---|
| `inbox/`를 README 외 미추적으로 변경 | 분류 전 자료의 민감도를 알 수 없어 default-deny가 안전함 |
| `refs/`를 생성하지 않음 | `origin/`과 `derived/` 역할에 포함되어 중복을 방지함 |
| `app/`에는 경계만 예약 | 기술 스택과 실제 기능 단위는 후속 작업에서 결정함 |
| 생애주기 표준을 `00`~`09` 10개로 시작 | 원본에 언급된 가이드 14종의 구체 목록이 제공되지 않음 |
| 별도 pre-commit 스크립트 대신 기존 gate에 통합 | 기존 Claude·Codex 검증 흐름을 단일 진입점으로 유지함 |
| UI 단계를 조건부 `template`로 유지 | 프로젝트의 화면 필요 여부가 아직 결정되지 않음 |

## 루트 유지 기준

다음 파일은 역할이 명확한 프로젝트 진입점 또는 agent 거버넌스이므로 루트에 유지합니다.

- `README.md`: 프로젝트 소개
- `PROJECT.md`: 도메인과 목표
- `REFERENCE.md`: 명령과 운영 절차
- `WORKFLOW.md`: 문서와 생애주기 라우터
- `AGENTS.md`, `CLAUDE.md`: agent 거버넌스

원본 자료와 분석·산출물은 루트에 두지 않고 `docs/`의 역할별 경로에 배치합니다. 현재 루트에는 재배치가 필요한 사용자 자료가 없습니다.

## 후속 작업 경계

루트 소개 문서를 실제 사이드 프로젝트 내용으로 재작성하고 애플리케이션·컨테이너 구조를 확정하는 작업은 [후속 WIP](../../wip/task-20260628-side-project-expansion/README.md)에서 수행합니다.
