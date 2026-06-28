---
document-id: baseline-policy
role: standard
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-28
source: internal
sensitivity: public
---

# 기준본 관리 절차

## 목적

승인된 표준 문서가 일반 수정으로 바뀌는 것을 방지하고 변경 근거를 추적합니다.

## 기준본 생성 조건

- `status: approved`인 표준 문서만 기준본으로 만들 수 있습니다.
- 기준본은 `docs/standards/_baseline/`에 원본과 같은 파일명으로 보관합니다.
- 기준본 생성 시 `MANIFEST.md`의 상태와 근거를 함께 갱신합니다.
- 현재 `approved` 상태인 문서가 없으므로 생성할 기준본도 없습니다.

## 변경 절차

1. 일반 표준 문서를 수정하고 상태를 `drafted`로 변경합니다.
2. 변경 내용과 완료 기준을 검토합니다.
3. 승인되면 상태를 `approved`로 변경합니다.
4. `_baseline/`의 대응 파일을 새 승인본으로 갱신합니다.
5. 커밋 제목은 한국어로 작성하고 본문에 `Rebaseline: <변경 사유>`를 기록합니다.

## 금지 사항

- 일반 표준 문서의 변경 없이 기준본만 수정하지 않습니다.
- `template`, `drafted`, `excluded` 상태 문서를 기준본으로 만들지 않습니다.
- `Rebaseline:` 사유가 없는 커밋에서 기준본을 변경하지 않습니다.

자동 강제 검사는 Phase 3에서 기존 completion checker에 통합합니다.
