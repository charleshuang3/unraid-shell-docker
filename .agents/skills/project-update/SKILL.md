---
name: project-update
description: >-
  Runbook for updating Docker base images, packages, and GitHub Actions in the
  unraid-shell-docker repository. Use when the user asks to update project
  dependencies, upgrade Docker/CI versions, or perform a routine dependency
  audit and bump.
---

# Project Update Runbook

Use this workflow when updating the Docker image configuration or GitHub Actions
in `unraid-shell-docker`.

## 1. Docker Base Image & Packages (`Dockerfile`)

Inspect `Dockerfile`:

- Base image: `FROM alpine:edge` (rolling tag used to pick up recent CLI
  tooling such as `go`, `zellij`, `lsd`, and `fish`).
- Installed packages: review `apk add --no-cache ...` packages for deprecated,
  renamed, or unneeded tools.
- Go CLI tool: `RUN go install github.com/charleshuang3/subget@latest` (rebuilt
  on every image build).

Verify the image builds cleanly with the latest base image:

```bash
docker build --pull -t unraid-shell-docker:test .
```

## 2. GitHub Actions & Dependabot

Inspect `.github/workflows/docker-img.yml` and `.github/dependabot.yml`.

GitHub Action versions are pinned by commit SHA with a `# vX.Y.Z` comment;
always update both the commit SHA and the version comment together:

- `actions/checkout`
- `docker/login-action`
- `docker/metadata-action`
- `docker/build-push-action`
- `actions/attest-build-provenance`

Check latest action versions and resolve their commit SHAs with `gh`:

```bash
for repo in \
  actions/checkout \
  docker/login-action \
  docker/metadata-action \
  docker/build-push-action \
  actions/attest-build-provenance
do
  tag=$(gh api "repos/$repo/releases/latest" --jq '.tag_name')
  obj_type=$(gh api "repos/$repo/git/ref/tags/$tag" --jq '.object.type')
  sha=$(gh api "repos/$repo/git/ref/tags/$tag" --jq '.object.sha')
  if [ "$obj_type" = "tag" ]; then
    sha=$(gh api "repos/$repo/git/tags/$sha" --jq '.object.sha')
  fi
  echo "$repo: $sha # $tag"
done
```

## 3. Verification

1. Build the Docker image locally if `Dockerfile` was modified (or to verify
   base image / package availability):
   ```bash
   docker build --pull -t unraid-shell-docker:test .
   ```
2. Check `git status` and `git diff` to verify only expected files changed, and
   commit using conventional commits (e.g., `ci: ...` or `build(deps): ...`).
