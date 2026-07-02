# REFERENCE.md — 실행 명령과 운영 절차

> RAG Retrieval Platform의 실행·검증·운영 명령. 도메인은 [PROJECT.md](PROJECT.md),
> 문서 라우터는 [WORKFLOW.md](WORKFLOW.md)를 참조한다.
>
> 아래 명령은 이 프로젝트를 개발하는 폴리에이전트 DevContainer 환경 기준이다.

## 애플리케이션 구조 및 실행

기능별 컨테이너 배포 단위는 `app/<deployment-unit>/`에 둔다
([ADR-0001](docs/deliverables/adr/0001-architecture-and-module-boundary.md)).

| 배포 단위 | 기술 | 성격 |
|---|---|---|
| `app/web-ui` | 웹 프론트엔드(기술 추후) | 코드 수정 단위 |
| `app/api-service` | Spring Boot | 코드 수정 단위(VS Code 디버깅) |
| `app/retrieval-service` | FastAPI | 코드 수정 단위 |
| `app/model-serving` | FastAPI | 코드 수정 단위 |
| `app/index-worker` | Java | 코드 수정 단위 |
| `app/search-store` | OpenSearch | 인프라 컨테이너 |
| `app/metadata-store` | MariaDB | 인프라 컨테이너 |
| `app/cache` | Redis | 인프라 컨테이너 |
| `app/message-queue` | RabbitMQ | 인프라 컨테이너 |

각 단위의 `dev`·`stg`·`prod` Dockerfile과 환경변수는 `app/<unit>/{dev,stg,prod}/`에
있다. 코드 수정 단위의 실행 명령(CMD)과 앱 코드는 M1에서 확정한다. 아래는 개발
환경(컨테이너·에이전트·문서 게이트) 명령이다.

## Privilege boundary

This template is **not** a security sandbox. The container mounts the
host's `/var/run/docker.sock` and the in-container user is in the
`docker` group, which Docker's official documentation describes as
equivalent to host root: anyone inside the container can launch
privileged containers, mount the host filesystem, and execute as root
on the host. This is required so that commands like
`docker compose build` and `devcontainer up` from inside the container
target the *host* daemon (not Docker-in-Docker).

Treat the container as a workspace boundary, not a trust boundary. Do
not run untrusted code or untrusted MCP tools inside it expecting
isolation from the host. If host-level isolation matters, run the
DevContainer inside a VM or on a dedicated machine.

## Configuration (`.devcontainer/.env`)

All user-tunable values live in `.devcontainer/.env`.

| Variable | Default | Used by | Purpose |
|----------|---------|---------|---------|
| `COMPOSE_PROJECT_NAME` | `polyagent-devcontainer` | docker-compose.yml | Docker namespace |
| `CONTAINER_NAME` | `polyagent-dev` | docker-compose.yml | Container name |
| `IMAGE_NAME` | `polyagent-devcontainer` | docker-compose.yml | Image name |
| `IMAGE_TAG` | `latest` | docker-compose.yml | Image tag |
| `TZ` | `UTC` | docker-compose.yml | Timezone |
| `PROJECT_NODE_VERSION` | *(empty)* | Dockerfile ARG | Project Node.js version (empty = not installed) |
| `HOST_WORKSPACE_PATH` | *(empty)* | docker-compose.yml volumes | HOST path for cross-namespace bind mounts (see `.claude/rules/devcontainer-patterns.md`) |

## Runtime isolation

```
AI agent infrastructure (kept separate from project code):
  Claude Code → native binary (~/.local/bin/claude, auto-updated)
  Codex CLI   → npm global (~/.npm-global/bin/codex)
  Node.js     → Node 22 LTS for Codex CLI infrastructure
  Python      → system python3 + uv (general development)

Project code (when PROJECT_NODE_VERSION is set):
  Node.js → project-node (nvm alias, .nvmrc auto-applied)
  Python  → install via deadsnakes / pyenv / etc.
  Other   → Go, Rust, etc. installed freely.

Aliases:
  project-node → Node ${PROJECT_NODE_VERSION}
  default      → project-node
```

## DevContainer lifecycle

```
Dockerfile ENTRYPOINT → entrypoint.sh (every container start)
  └── setup-env.sh (idempotent; postCreateCommand runs it once on first build)
        [1/5] Permissions   — Docker socket ownership, git core.filemode,
                              git safe.directory, command-history setup
        [2/5] SSH            — chmod 700/600/644 on ~/.ssh keys (optional)
        [3/5] Claude CLI     — `claude update` (skip with SKIP_CLAUDE_UPDATE=1)
        [4/5] Codex CLI      — reconcile PATH-first launcher, then refresh the
                              real ~/.npm-global/bin/codex with npm --prefix
                              (skip with SKIP_CODEX_UPDATE=1)
        [5/5] Codex config   — validate project config; preserve user config without copying

postStartCommand (every start, devcontainer.json)
  git config core.filemode false
```

Both `docker compose up` and VS Code "Reopen in Container" route through
`entrypoint.sh`, so the 5 steps run regardless of how the container was started.
The container healthcheck requires both agent CLIs and a recognizable
`/workspaces` project marker (`.git`, `AGENTS.md`, `CLAUDE.md`, `README.md`, or
`.devcontainer/`). A container with an empty or mis-mounted workspace stays
`unhealthy` instead of reporting a false green status.

## Persistent volumes

| Volume | Mount | Purpose |
|--------|-------|---------|
| `claude-config` | `~/.claude` | Claude Code auth (survives rebuild) |
| `codex-config` | `~/.codex`  | Codex CLI auth (survives rebuild) |
| `command-history` | `/commandhistory` | Shell history |

> Named volumes are prefixed by `COMPOSE_PROJECT_NAME` and shared identically by
> both entry paths (`docker compose up` and VS Code "Reopen in Container").
> Change `COMPOSE_PROJECT_NAME` in `.devcontainer/.env` to isolate volumes per instance.

## Pre-installed tools

| Category | Tools |
|----------|-------|
| Shell | tmux, zsh, fzf, jq, tree, htop |
| Search | ripgrep (rg), fd-find (fd) |
| Git | git, git-lfs, gh |
| Container | docker CLI, docker compose v2, devcontainer CLI |
| Editor | vim, nano |
| Network | curl, wget, openssh-client |
| Claude | Claude Code CLI |
| Codex | Codex CLI (npm global), AGENTS.md, `.codex/` hooks |
| Node.js | Node 22 LTS, npm, npx |
| Python | python3, uv, ruff, pytest, mypy |

### Tool versioning policy: rolling, not pinned

The template intentionally pulls latest releases at build/run time:
- **Claude Code**: `curl https://claude.ai/install.sh | bash` (latest at build).
- **Codex CLI**: `npm install -g --prefix ~/.npm-global @openai/codex`
  into `~/.npm-global` (latest published, unpinned). The image installs a
  PATH-first `codex` launcher (`/usr/local/bin/codex-launcher`) that updates
  through the same explicit prefix, then re-execs the real
  `~/.npm-global/bin/codex` binary. The template does not persistently mutate
  npm's global prefix.
- **`claude update`**: runs on every container start (`setup-env.sh` step 3),
  unless `SKIP_CLAUDE_UPDATE=1` is set.
- **Codex update**: every container start reconciles the launcher symlinks and
  delegates refresh to `/usr/local/bin/codex-launcher --update-only`, which
  updates the real binary with `npm install -g --prefix ~/.npm-global
  @openai/codex@latest`, unless `SKIP_CODEX_UPDATE=1` is set. The same launcher
  performs the preflight before every new `codex` process. Codex's built-in
  `codex update` is **not** used: it targets the root-owned default npm prefix
  (`/usr/lib/node_modules`) and fails as the unprivileged `vscode` user.

Same git commit may produce different installed versions on different days.
For reproducible images, pin: replace the Claude installer URL with a tagged
release, set `npm install -g @openai/codex@<version>`, and export
`SKIP_CLAUDE_UPDATE=1` and `SKIP_CODEX_UPDATE=1` in `devcontainer.json`.

## Agent system

### Governance roles (2)

| Agent | Purpose | Invocation |
|-------|---------|------------|
| evaluator | Context-isolated quality evaluation | After changes; within `/refine` |
| wip-manager | Multi-session task tracker | When task spans sessions |

Current Codex supports in-process subagents and project
`.codex/agents/*.toml`. The template mirrors these Claude role bodies as Codex
skills for portable discovery; evaluator runs still use a fresh
`codex exec --ephemeral` process to enforce the exact Contract/diff-only input
boundary in interactive and non-interactive flows.

### Hooks

Claude (4): `session-start.sh`, `pre-commit-gate.sh`, `pre-push-gate.sh`, `refinement-gate.sh`.

Codex (4): `session-start.sh`, `pre-commit-gate.sh`, `pre-push-gate.sh`,
`refinement-gate.sh`. Codex matchers support `Bash`, `apply_patch`, `Edit`, and
`Write`; these commit/push gates intentionally inspect `Bash` commands.

Codex loads `.codex/config.toml` directly after the project is trusted. Project
command hooks also require review in `/hooks`, and changed definitions are
skipped until reviewed again. Use `--dangerously-bypass-hook-trust` only in
automation that independently vets the hook source.

### Skills (4)

| Skill | Description |
|-------|-------------|
| /refine | Autonomous iterative refinement loop |
| /status | Workspace status |
| /verify | Pre-commit verification |
| karpathy-guidelines | Reference handle for the Karpathy 4 rules (`SKILL.md` + `EXAMPLES.md`) |

## Polyagent parity

```bash
bash scripts/sync-agents-mirror.sh         # .claude/ → .agents/ generated mirror
bash scripts/sync-agents-mirror.sh --dry   # diff only
```

`.claude/` is ground truth; `.agents/` is generated. The sync copies content
and file modes, and **prunes** `.agents/` entries whose `.claude/` source was
deleted, so the mirror tracks metadata and deletions, not just additions.

## 프로젝트 문서 검사

```bash
bash scripts/meta/workflow-gate.sh
bash scripts/meta/docs-link-check.sh
bash scripts/meta/workflow-gate-test.sh
```

전체 검증은 위 검사를 기존 템플릿 검사와 함께 실행합니다.

```bash
CODEX_PROJECT_DIR=/workspaces AGENT_VENDOR=codex \
  bash scripts/meta/completion-checker.sh
```

기준본을 변경하는 커밋은 한국어 제목을 사용하고 본문에
`Rebaseline: <변경 사유>`를 포함해야 합니다.

### Codex sandbox bypass (DevContainer only)

Codex CLI sandboxes commands with [bubblewrap](https://github.com/containers/bubblewrap), which requires unprivileged user namespaces. Docker kernel policy blocks namespace creation, so every shell call from the sandbox fails (`bwrap: No permissions to create a new namespace`).

| Environment | Sandbox works | Recommended |
|-------------|:-------------:|-------------|
| Host Linux directly | ✓ | (default) `--sandbox workspace-write` |
| **DevContainer** | ✗ (kernel) | `--dangerously-bypass-approvals-and-sandbox` |

The bypass makes the DevContainer the command-execution compatibility boundary,
not a security or trust boundary. The mounted Docker socket grants host-level
power; outside containers, keep the default sandbox.

### Codex commands

```bash
codex login --device-auth                                                # auth (volume-persistent)
codex login status                                                       # auth status
codex                                                                    # interactive (loads AGENTS.md)
codex exec --skip-git-repo-check --dangerously-bypass-approvals-and-sandbox "<prompt>"
codex exec --dangerously-bypass-hook-trust "<vetted-automation-prompt>"    # vetted hooks only
codex --version
```

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Build fails | `docker compose build --no-cache` |
| Claude re-auth needed | check named volume: `docker volume ls \| grep claude-config` |
| Codex re-auth needed | check named volume: `docker volume ls \| grep codex-config` |
| Codex says `Run npm install -g @openai/codex to update` | restart the current Codex process; new sessions enter through the launcher and re-exec the latest real binary |
| Strict config rejects `ask_for_approval` | replace it with `approval_policy` in `~/.codex/config.toml`; project config is not copied there |
| Wrong Node version | `nvm use` or create `.nvmrc` |
| Hook test fails | `export CLAUDE_PROJECT_DIR=/workspaces` (Codex: `CODEX_PROJECT_DIR`) |
| Git permission errors | `git config core.filemode false` |
| `.agents/` drift | `bash scripts/sync-agents-mirror.sh` |

---

*Last updated: 2026-06-29*
