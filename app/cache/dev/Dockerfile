# app/cache (dev) — Redis 응답 캐시 / 단일 노드, 디버그 친화
# 공식 이미지 위의 얇은 레이어. 비밀번호 없음, 작은 maxmemory.
# redis:7 — exact patch version은 M1에서 확정.
FROM redis:7

# 로케일/타임존 통일
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# TODO(M1): redis.conf 작성 후 활성화
#   COPY redis.conf /usr/local/etc/redis/redis.conf
#   dev 설정값(REDIS_MAXMEMORY 등)은 .env.example 참고. 아직 conf 파일 없음.

EXPOSE 6379

# 공식 이미지 내장 non-root redis 사용자로 실행
USER redis

# dev: 기본 설정으로 단일 노드 구동 (비밀번호/eviction 없음)
CMD ["redis-server"]
