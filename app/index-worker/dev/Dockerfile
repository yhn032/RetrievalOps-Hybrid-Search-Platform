# index-worker (dev) — Python async indexing worker (worker process, no inbound HTTP port)
# Base는 major tag로만 고정. 정확한 patch 버전은 M1에서 확정.
FROM python:3.12-slim

# 타임존/로케일 표준화
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# dev: 디버깅 편의 (unbuffered stdout, .pyc 미생성)
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1

# VS Code bind-mount 소유권을 host와 일치시키기 위한 UID/GID (code-editing unit)
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
    && useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash app

WORKDIR /app

# TODO(M1): copy built artifact / install app deps (requirements.txt, pip install)
#           job queue는 DB work-table 기반 (ADR-0004)

USER app

# TODO(M1): set real entrypoint, e.g. CMD ["python", "-m", "index_worker"]
CMD ["python", "-c", "import sys; sys.exit('index-worker(dev): app code arrives in M1')"]
