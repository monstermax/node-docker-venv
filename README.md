
# Node Docker Venv

A tiny self-extracting installer that bootstraps a Docker-based “venv-like” environment for Node projects. It drops minimal files in your repo and lets you keep all configuration in `.envrc`. No npm required.

## What it installs

* `.envrc` (project entrypoint; enable with `direnv allow`)
* `.envrc.sandbox` (helper sourced by `.envrc`)

> The release artifact is a single shell script: `node-docker-venv.sh`. Your build step creates it from the `template/` payload.&#x20;

## How does it work?
1. The .envrc.sandbox/bin folder is added to the $PATH
2. The .envrc.sandbox/bin folder contains scripts that associate the main Node executables with a Docker container (node, npm, npx, ts-node).

The Docker container is based on the official Node.js Docker images, with the simple addition of "ts-node" for native TypeScript support.

## Requirements

* Linux/macOS shell with `bash`, `tar`, `gzip`, `curl`
* Docker (or Podman, if you adapt your own scripts)
* [direnv](https://direnv.net) (to auto-load `.envrc`)


## Install from sources (Recommanded)

```bash
git clone https://github.com/monstermax/node-docker-venv
cd node-docker-venv
./build_package.sh

# Then
cd /path/to/your/project
/path/to/node-docker-venv/dist/node-docker-venv.sh .

# Or
/path/to/node-docker-venv/dist/node-docker-venv.sh /path/to/your/project
```

This creates `dist/node-docker-venv.sh` by concatenating the installer stub with a tar.gz payload from the `template/` directory (currently bundling `.envrc.sandbox` and `.envrc`).


## Install from dist (Quick but Not recommanded)

```bash
cd /path/to/your-project

curl -fsSLo /tmp/node-docker-venv.sh https://github.com/monstermax/node-docker-venv/raw/refs/heads/master/dist/node-docker-venv.sh \
  && bash /tmp/node-docker-venv.sh .
```

```bash
cd /path/to/your-project

curl -fsSLo /tmp/node-docker-venv.sh https://github.com/monstermax/node-docker-venv/raw/refs/heads/master/dist/node-docker-venv.sh
chmod +x /tmp/node-docker-venv.sh
/tmp/node-docker-venv.sh            # prompts for target dir; default = $PWD

# or non-interactive:
/tmp/node-docker-venv.sh /path/to/your-project
```


```bash
direnv allow
```


## Notes

* The installer prompts for a **target directory** if not passed as `$1`; it errors out if the directory doesn’t exist (no automatic creation).
* Designed to be minimal, idempotent, and easy to version alongside your projects.


## Usage

Once installed and `direnv` is allowed in the project folder:

* configure everything in `.envrc` (example: `export PORTS="3000,9229"`),
* open a new shell in the project directory,
* use your regular commands (`node`, `npm`, `npx`, etc.)—they’ll run inside the sandbox if your wrappers/runner do so.


## Configuration

Put all project-specific settings in `.envrc` (kept in the repo). Typical examples:

```bash
# .envrc
export PORTS="3000,9229"   # ports are mapped 1:1 (3000->3000, 9229->9229)

# …
```

Then:

```bash
direnv allow
```

## Update

Re-run a newer installer.


## Uninstall

Remove the files/folders you added to the repo (at minimum `.envrc` and `.envrc.sandbox`). If you committed them, remove from VCS too.
