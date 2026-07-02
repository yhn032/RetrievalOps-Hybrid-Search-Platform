# index-worker (prod) — Java·Spring 색인 워커, 최소 런타임
# Multi-stage slim: build=jdk, runtime=jre. 정확한 patch 버전은 M1에서 확정.

# ---- build stage ----
FROM eclipse-temurin:21-jdk AS build
WORKDIR /build
# TODO(M1): copy source / install app deps + ./gradlew bootJar (코드는 M1 이후)

# ---- runtime stage ----
FROM eclipse-temurin:21-jre

# 로케일/타임존 고정
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# 비루트 사용자 (code-editing 유닛 규약: HOST_UID/GID 수용)
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
 && useradd -u ${HOST_UID} -g ${HOST_GID} -m -s /bin/bash app

WORKDIR /app

ENV SPRING_PROFILES_ACTIVE=prod
# 컨테이너 메모리 한도에 맞춰 힙 자동 조정 (no debug)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0"

# TODO(M1): COPY --from=build /build/app.jar /app/app.jar

USER app

# worker process — inbound HTTP 포트 없음 (EXPOSE 없음, message-queue 소비, ADR-0004)
# prod: 디버그 비활성. CPU/메모리 한도는 오케스트레이터/compose 에서 설정.
# TODO(M1): CMD ["sh","-c","java $JAVA_OPTS -jar app.jar"]
