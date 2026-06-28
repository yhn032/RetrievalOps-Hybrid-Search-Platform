# index-worker (prod) — Python async indexing worker (worker process, no inbound HTTP port)
# 최소 런타임. Base는 major tag 고정, patch는 M1 확정.
FROM python:3.12-slim

# 타임존/로케일 표준화
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# 로그 캡처용 unbuffered, .pyc 미생성
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1

# VS Code bind-mount 소유권 정합용 UID/GID (code-editing unit)
ARG HOST_UID=1000
ARG HOST_GID=1000
# prod: nologin 셸 (no interactive/debug tooling)
RUN groupadd -g ${HOST_GID} app \
    && useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /usr/sbin/nologin app

WORKDIR /app

# TODO(M1): install app deps with `pip install --no-cache-dir` (no debug tooling)
#           job queue는 DB work-table 기반 (ADR-0004)

# 비루트 실행. CPU/memory 등 resource limit은 orchestrator(compose/k8s)에서 강제.
USER app

# TODO(M1): set real entrypoint, e.g. CMD ["python", "-m", "index_worker"]
CMD ["python", "-c", "import sys; sys.exit('index-worker(prod): app code arrives in M1')"]
