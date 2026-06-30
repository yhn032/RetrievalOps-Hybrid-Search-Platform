---
document-id: standard-07-security
role: standard
stage: "07"
status: approved
owner: yhn032
updated: 2026-06-30
source: internal
sensitivity: public
---

# 07 보안

## 목적

데이터·인증정보·의존성·외부 연동에서 발생할 위험을 식별하고 통제한다.

## 적용 기준

- 비밀값은 추적하지 않는다: `.env`는 Git에서 제외하고 `.env.example`에는
  placeholder만 둔다. 실데이터·고객 데이터는 사용하지 않는다(공개 데이터만).
- 컨테이너는 비루트로 기동하고 코드 단위는 호스트 UID/GID를 맞춘다
  ([런타임·배포](../deliverables/runtime-and-deployment.md), `runtime-rules-check.sh`).
- API는 입력을 검증하고 오류 메시지에 민감 정보를 노출하지 않는다.
- 의존성은 고정·점검하고, 알려진 위험과 수용 근거를 기록한다.
- 현 단계의 수용 위험을 기록한다: 공개 데이터만 사용해 실데이터 유출 위험을
  회피하며, 의존성·외부 연동 위험은 발생 시점(M1 이후)에 본 문서에 추가 기록한다.

## 완료 기준

- 민감 데이터·비밀값이 추적 대상과 분리되어 있다.
- 입력 검증과 오류 노출 통제가 적용되어 있다.
- 알려진 위험과 수용 근거가 기록되어 있다.
