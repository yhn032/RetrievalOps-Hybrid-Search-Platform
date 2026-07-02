# Model Serving (FastAPI embedding/reranker inference) — dev
# base: python:3.12-slim (정확한 patch 버전은 M1에서 확정)
FROM python:3.12-slim

# 로케일/타임존 표준화
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1

# 호스트 UID/GID 와 일치하는 비루트 사용자 (VS Code bind-mount 편집 권한 정렬)
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
 && useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash app

WORKDIR /app

# TODO(M1): copy built artifact / install app deps
#   예) COPY requirements.txt . && pip install -r requirements.txt
#   dev 에서는 소스를 bind-mount 하고 uvicorn --reload 로 실행
# 모델·런타임(GPU·vLLM 등) 선택은 M2에서 확정 — dev 는 cpu 기본

USER app
EXPOSE 8001

# dev: 단일 워커 + reload + debug 로깅 (진입점은 M1 확정 후 활성화)
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001", "--reload", "--log-level", "debug"]
