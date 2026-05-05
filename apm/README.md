# APM

Agent Package Manager configuration for shared agent dependencies.

This directory is the source of truth for APM-managed agent packages. The
manifest intentionally starts with external Claude official plugins that are
already used locally. Codex native plugin enablement still lives in
`~/.codex/config.toml` because APM's Codex support is currently strongest for
compiled instructions and cross-client skills.

## Usage

Install the APM CLI through mise:

```bash
mise install github:microsoft/apm
```

The `apm:*` mise tasks link this repository's APM directory into the user-scope
APM directory automatically:

```bash
~/.apm -> ~/dotfiles/apm
```

Preview what APM would deploy:

```bash
mise run apm:dry-run
```

Audit installed APM packages and the manifest:

```bash
mise run apm:audit
```

Install the manifest to user scope:

```bash
mise run apm:install
```

Update managed dependencies and then audit the result:

```bash
mise run apm:update
mise run apm:audit
```

The mise tasks run from this directory and call:

```bash
apm install --global
```

`mise run apm:audit` creates a temporary audit root and symlinks `apm.yml`,
`apm.lock.yaml`, `.claude`, and `.agents` into it. This mirrors APM's
lockfile-relative deployed paths while keeping the source manifest in `~/.apm`.

## CI

The GitHub Actions workflow uses `jdx/mise-action`, installs
`github:microsoft/apm` through mise, uses a temporary `HOME`, installs this
manifest with `--global`, and runs `apm audit --ci`. This checks dependency
resolution, deployment, and basic supply-chain hygiene without touching a real
developer home directory.
