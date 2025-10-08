
# Node Docker Venv

A tiny self-extracting installer that bootstraps a Docker-based “venv-like” environment for Node projects. It drops minimal files in your repo and lets you keep all configuration in `.envrc`. No npm required.

## What it installs

* `.envrc` (project entrypoint; enable with `direnv allow`)

> The release artifact is a single shell script: `node-venv-installer.sh`. Your build step creates it from the `template/` payload.&#x20;

## How does it work?
1. The $HOME/.node-docker-venv/venv_lib/bin folder is added to the $PATH
2. The $HOME/.node-docker-venv/venv_lib/bin folder contains scripts that associate the main Node executables with a Docker container (node, npm, npx, ts-node).

The Docker container is based on the official Node.js Docker images, with the simple addition of "ts-node" for native TypeScript support.

## Requirements

* Linux/macOS shell with `bash`, `tar`, `gzip`, `curl`
* Docker (or Podman, if you adapt your own scripts)
* [direnv](https://direnv.net) (to auto-load `.envrc`)



## direnv Install

```bash
apt install direnv
```

Add this at the end of ~/.bashrc
```bash
# direnv autoload
eval "$(direnv hook bash)"

```


## Install from sources (Recommanded)

```bash
cd /tmp

git clone https://github.com/monstermax/node-docker-venv
cd node-docker-venv

# This creates `dist/node-venv-installer.sh` by concatenating the installer stub with a tar.gz payload from the `template/` directory.
./build_installer.sh

# Then, install it into $HOME/.node-docker-venv
./dist/node-venv-installer.sh .
```



## Install from dist (Quick but Not recommanded)

```bash
curl -fsSLo /tmp/node-venv-installer.sh https://github.com/monstermax/node-docker-venv/raw/refs/heads/master/dist/node-venv-installer.sh \
  && bash /tmp/node-venv-installer.sh .
```


## Activate a new venv

```bash
cd /path/to/your-project

node-venv
```



## Notes

* The installer prompts for a **target directory** if not passed as `$1`; it errors out if the directory doesn’t exist (no automatic creation).
* Designed to be minimal, idempotent, and easy to version alongside your projects.


## Usage

Once installed and `direnv` is allowed in the project folder:

* configure everything in `.envrc`,
* open a new shell in the project directory,
* use your regular commands (`node`, `npm`, `npx`, etc.)—they’ll run inside the sandbox if your wrappers/runner do so.


## Configuration

Put all project-specific settings in `.envrc` (kept in the repo).

```


## Update

Re-run a newer installer.


## Uninstall from your project

Remove the `.envrc`. If you committed them, remove from VCS too.


## Uninstall globally

Remove the files/folders into `$HOME/.node-docker-venv`


