# node-docker-venv

A lightweight tool that gives every Node.js project its own isolated Docker container — the same mental model as Python's `venv`, without touching your system or using version managers like `nvm`.

Each project gets a dedicated container based on the official Node.js Docker images. Commands like `node`, `npm`, `npx`, `tsc`, `tsx` and `ts-node` transparently run inside it.

---

## How it works

1. `install.sh` copies the runtime files into `~/.node-docker-venv/` and symlinks `node-venv-init` into `~/.local/bin/`.
2. In a project, `node-venv-init` drops a `.envrc` file and calls `direnv allow`.
3. On every `cd` into the project, `direnv` sources `.envrc`, which starts the Docker container (if not already running) and prepends the venv binaries to `$PATH`.
4. From that point, `node`, `npm`, `npx`, etc. silently delegate to `docker exec` inside the container.

---

## Requirements

- Linux or macOS with `bash`
- [Docker](https://docs.docker.com/get-docker/)
- [direnv](https://direnv.net)

### Install direnv

```bash
# Debian / Ubuntu
sudo apt install direnv

# macOS
brew install direnv
```

Add to your `~/.bashrc` (or `~/.zshrc`):

```bash
eval "$(direnv hook bash)"
export PATH="$PATH:$HOME/.local/bin"
```

---

## Installation

```bash
git clone https://github.com/monstermax/node-docker-venv
cd node-docker-venv
./install.sh
```

By default, files are installed into `~/.node-docker-venv`.  
To use a custom path:

```bash
NDV_DIR=~/tools/ndv ./install.sh
```

> If you use a custom `NDV_DIR`, make sure to export it in your shell profile so direnv can find it at project activation time.

---

## Global configuration

Edit `~/.node-docker-venv/config/config` to set your preferred defaults for all new projects:

```bash
# Set your preferred Node version (used as default by node-venv-init)
export NDV_DEFAULT_NODE_VERSION="22-bookworm-slim"
```

---

## Initialise a project

```bash
cd /path/to/your-project
node-venv-init
```

The script asks for the project name and Node version interactively.  
Press Enter to accept the defaults.

**Skip all prompts** (use defaults silently):
```bash
node-venv-init -y
```

**Also configure resource limits** interactively:
```bash
node-venv-init -r
```

This creates a `.envrc` in the project directory and activates it immediately.  
Commit `.envrc` to keep the configuration in version control.

---

## Per-project configuration

All settings live in `.envrc`:

```bash
# Node version
export VENV_NODE_VERSION="22-alpine"

# Resource limits (default: unlimited)
#export VENV_MEM_LIMIT=512m
#export VENV_CPU_LIMIT=2
#export VENV_PIDS_LIMIT=200
```

After editing `.envrc`, run `direnv allow` to reload.

> **Any change to `.envrc`** requires rebuilding the container to take effect:
> ```bash
> ndv-rebuild
> ```

---

## Commands

| Command          | Description                                          |
|------------------|------------------------------------------------------|
| `node-venv-init` | Initialise a venv in the current project             |
| `node-venv-init -y` | Same, non-interactive (use defaults)              |
| `node-venv-init -r` | Also prompt for resource limits                   |
| `ndv-status`     | Show venv config and container state                 |
| `ndv-shell`      | Open a bash shell inside the container               |
| `ndv-shell-root` | Open a bash shell as root inside the container       |
| `ndv-stop`       | Stop the container                                   |
| `ndv-rebuild`    | Destroy the image and rebuild from scratch           |
| `ndv-create-wrapper <exec>` | Create a symlink wrapper in `.envrc.bin/` |
| `ndv-create-wrapper-interactive <exec>` | Create a standalone interactive wrapper (`-ti`) |
| `ndv-create-wrapper-non-interactive <exec>` | Create a standalone non-interactive wrapper (`-i`), for editors and CI |

---

## Project-local binaries

You can add project-specific scripts to `.envrc.bin/` at the root of your project.  
That directory is automatically added to `$PATH` when the venv is active.

---

## Update

Pull the latest version and re-run the installer:

```bash
cd /path/to/node-docker-venv
git pull
./install.sh
```

The installer is idempotent — safe to run multiple times.

---

## Uninstall

**From a project:** remove `.envrc` (and drop it from version control if committed).

**Globally:**
```bash
rm -rf ~/.node-docker-venv
rm ~/.local/bin/node-venv-init
```

---

## Adding binaries to the venv

Any binary installed inside the container (via `npm install -g`) can be exposed to your shell using the wrapper commands.

**Simple case** — symlink to the generic wrapper (same as `node`, `npm`, etc.):
```bash
ndv-create-wrapper <binary_name>
```

**Interactive wrapper** — generates a standalone script with `docker exec -ti`, useful when `$VENV_CONTAINER` needs to be hardcoded (e.g. called from an editor):
```bash
ndv-create-wrapper-interactive <binary_name>
```

**Non-interactive wrapper** — same but with `docker exec -i`, for tools that don't allocate a TTY (VSCode extensions, CI pipelines, etc.):
```bash
ndv-create-wrapper-non-interactive <binary_name>
```

The generated wrappers are placed in `.envrc.bin/`, which is automatically added to `$PATH` when the venv is active.

### Example: Claude Code

```bash
npm install -g @anthropic-ai/claude-code
ndv-create-wrapper-non-interactive claude
```

If you use the same project directory across multiple machines, leave `VENV_CONTAINER` dynamic (default). If you need the wrapper to work outside of direnv (e.g. pointed to by a VSCode extension path), uncomment and hardcode `VENV_CONTAINER` inside the generated script.
