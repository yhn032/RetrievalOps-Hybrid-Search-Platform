# Retrieval Service (FastAPI embedding/reranker) — prod
# base: python:3.12-slim (정확한 patch 버전은 M1에서 확정)
FROM python:3.12-slim

# 로케일/타임존 표준화
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1

# 비루트 사용자 (최소 런타임; 디버그 도구 미설치)
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
 && useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /usr/sbin/nologin app

WORKDIR /app

# TODO(M1): copy built artifact / install app deps (런타임 의존성만)
#   예) COPY requirements.txt . && pip install --no-cache-dir -r requirements.txt
#       COPY ./app ./app

USER app
EXPOSE 8000

# prod: 다중 워커 + reload 비활성 + info 로깅 (자원 한도는 compose/orchestrator 에서 적용)
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4", "--log-level", "info"]
