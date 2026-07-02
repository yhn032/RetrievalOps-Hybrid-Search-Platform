# Model Serving (FastAPI embedding/reranker inference) — stg
# base: python:3.12-slim (정확한 patch 버전은 M1에서 확정)
FROM python:3.12-slim

# 로케일/타임존 표준화
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1

# prod-like 비루트 사용자 (스테이징 검증; 호스트 UID/GID 정렬)
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
 && useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash app

WORKDIR /app

# TODO(M1): copy built artifact / install app deps
#   예) COPY requirements.txt . && pip install --no-cache-dir -r requirements.txt
#       COPY ./app ./app
# 모델·런타임(GPU·vLLM 등) 선택은 M2에서 확정 — GPU base 이미지 전환 여부 포함

USER app
EXPOSE 8001

# stg: prod 와 동일 구성, 스테이징 값 사용 (.env.example 참고)
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001", "--workers", "2", "--log-level", "info"]
