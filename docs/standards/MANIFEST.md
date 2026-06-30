---
document-id: lifecycle-manifest
role: standard
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-30
source: internal
sensitivity: public
---

# 생애주기 상태

## 상태 정의

| 상태 | 의미 |
|---|---|
| `template` | 문서 구조만 있고 프로젝트 내용은 작성되지 않음 |
| `drafted` | 프로젝트 내용이 작성됐으나 승인되지 않음 |
| `approved` | 완료 기준을 충족해 다음 단계의 근거로 사용 가능 |
| `excluded` | 프로젝트에 적용하지 않으며 사유가 기록됨 |

## 단계 현황

| 단계 | 표준 | 적용 | 상태 | 근거 또는 배제 사유 |
|---|---|---|---|---|
| 00 공통 | [00-common.md](00-common.md) | 필수 | `approved` | 공통 기준 승인, 기준본 생성 |
| 01 수령 | [01-intake.md](01-intake.md) | 필수 | `approved` | 수령·격리 기준 승인, 기준본 생성 |
| 02 아키텍처 | [02-architecture.md](02-architecture.md) | 필수 | `approved` | 아키텍처 표준 승인, 기준본 생성 |
| 03 UI | [03-ui.md](03-ui.md) | 필수 | `approved` | UI 표준 승인, 기준본 생성 |
| 04 API | [04-api.md](04-api.md) | 필수 | `drafted` | 인터페이스 계약·오류 형식 정의 |
| 05 코딩 | [05-coding.md](05-coding.md) | 필수 | `drafted` | 언어별 구조·변경 단위 기준 |
| 06 테스트 | [06-testing.md](06-testing.md) | 필수 | `drafted` | 단위·통합·검색 품질 평가 기준 |
| 07 보안 | [07-security.md](07-security.md) | 필수 | `drafted` | 비밀·비루트·입력 검증 기준 |
| 08 배포 | [08-deployment.md](08-deployment.md) | 필수 | `drafted` | dev·stg·prod 분리·재현 기준 |
| 09 운영 | [09-operations.md](09-operations.md) | 필수 | `drafted` | 관측·지표·장애 대응 기준 |

## 관리 문서

| 문서 | 상태 | 역할 |
|---|---|---|
| [WORKFLOW.md](../../WORKFLOW.md) | `drafted` | 최상위 라우터 |
| [document-metadata.md](document-metadata.md) | `drafted` | 메타데이터 규격 |
| [baseline-policy.md](baseline-policy.md) | `drafted` | 기준본 관리 절차 |

## 상태 변경 규칙

1. 상태 변경은 해당 단계 문서의 실제 내용과 함께 수행합니다.
2. `excluded`에는 적용하지 않는 이유를 반드시 기록합니다.
3. `approved`는 단계 문서의 완료 기준을 모두 충족한 경우에만 사용합니다.
4. 선행 단계가 `approved` 또는 사유가 있는 `excluded` 상태가 아니면 다음 단계에 진입하지 않습니다.
