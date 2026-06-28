# api-service (stg) — Spring Boot REST API, prod-like(staging 값)
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

ENV SERVER_PORT=8080
ENV SPRING_PROFILES_ACTIVE=stg

# TODO(M1): COPY --from=build /build/app.jar /app/app.jar

USER app
EXPOSE 8080

# stg: no debug. 산출물 도착 후 아래 CMD 활성화.
# TODO(M1): CMD ["java","-jar","app.jar"]
