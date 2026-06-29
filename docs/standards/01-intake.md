---
document-id: standard-01-intake
role: standard
stage: "01"
status: drafted
owner: yhn032
updated: 2026-06-29
source: internal
sensitivity: public
---

# 01 수령

## 목적

프로젝트 목표·요구사항·제약과 전달받은 원본을 식별하고 안전하게 격리한다.

## 적용 기준

- 전달받은 원본은 `docs/intake/`에 두고 default-deny로 Git에서 제외한다(README만 추적).
- 원본에서 추출한 요구사항·아키텍처는 복사하지 않고 재작성하며, 파생 문서에
  source ID를 기록한다. 본 프로젝트 원본·배치는
  [원본 분석](../derived/side-project-source-analysis.md)을 따른다.
- 요구사항은 [요구사항 문서](../derived/side-project-requirements.md)로 관리한다.
- 민감 자료(실측 지표·역할 경계 등)는 추적 문서로 옮기지 않는다.

## 완료 기준

- 원본 자료가 `docs/intake/`에 격리되어 있고 민감·권리 불명확 원본이 Git에서 제외된다.
- 기능·비기능 요구사항이 목록화되어 있다.
- 추적 가능한 파생 문서에 원본 출처(source ID)가 기록되어 있다.
