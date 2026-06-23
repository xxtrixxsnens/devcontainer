# DEV Containers
This Repository contains Containerfiles that build Alpine-based environments to run tools for local development (Node, Python).

## Design & Guidelines

- **Alpine Linux Base**: All containers use the same version of Alpine (`alpine3.20`) to keep images small, secure, and aligned.
- **Rootless Podman Support**: The user namespace mapping `userns_mode: "keep-id"` is required. This maps your host user identity to the container's main user, enabling seamless permissions on mounted directories.
- **Main User**: The default container user is `cloud` (UID 1000, GID 1000).
- **Mount Point**: The host repository is mounted to `/workplace`.

## Supported Environments

### Python 3.13 (`Containerfile.python`)
- Uses Python 3.13 on Alpine 3.20.
- Installs `build-base`, `curl`, `gosu`, `git`, `bash`, and Neovim.
- **Persistent Dependencies**: Automatically initializes a virtual environment at `/workplace/.venv` and installs packages from `requirements.txt` to it on startup.
- **Caching**: Pip wheels are cached on the host at `/workplace/.cache/pip` to speed up subsequent package installations.

### Node / pnpm / Vite / TypeScript (`Containerfile.node`)
- Uses Node 20 on Alpine 3.20.
- Enables Corepack and activates `pnpm@9.4.0`.
- Installs `build-base`, `curl`, `bash`, `git`, and Neovim.
- **Persistent Dependencies**: Automatically runs `pnpm install` on startup to link dependencies in `/workplace/node_modules`.
- **Caching**: The pnpm global store is cached on the host at `/workplace/.pnpm-store` to make installation runs near-instantaneous.

## Getting Started

To build and start the environments, use `podman-compose` or `docker-compose`:

```bash
# Start the Node development container
podman-compose -f container-compose.dev.yml up -d node-dev

# Start the Python development container
podman-compose -f container-compose.dev.yml up -d python-dev
```

You can then run interactive commands or start editing files inside the containers:

```bash
# Run Neovim inside the running Node container
podman exec -it node_dev nvim .

# Run Python code inside the running Python container
podman exec -it python_dev python main.py
```

## CI/CD & Pre-built Images

This repository includes a GitHub Actions workflow that automatically builds and pushes the development images on pushes to the `main` branch. 

The images are built as multi-architecture images supporting both **AMD64** (x86_64) and **ARM64** (Apple Silicon, etc.) platforms, and are published to the **GitHub Container Registry (GHCR)**:

- **Node Dev Image:** `ghcr.io/<owner>/<repository>/node-dev:latest`
- **Python Dev Image:** `ghcr.io/<owner>/<repository>/python-dev:latest`

### Tags Available

- `latest`: Always tracks the latest commit on `main`.
- `alpine3.20`: Specific to the base Alpine version used.
- `3.20`: Alias for Alpine version.
- `sha-<short-sha>`: Built for specific commits.

