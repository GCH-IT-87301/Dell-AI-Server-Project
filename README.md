# Dell AI Server Project

A small homelab project to keep capable Dell micro-form-factor hardware out of the e-waste stream while learning about Linux, containers, local large language models, and self-hosted services.

## Project goals

- Reuse older business-class hardware instead of discarding it.
- Run local LLMs privately with Ollama.
- Provide a browser interface with Open WebUI.
- Keep the build simple, documented, reproducible, and easy to troubleshoot.
- Compare model speed, memory use, and usefulness on modest CPU-only hardware.

## Tested lab configuration

The proof of concept was built in an Ubuntu Server 24.04 virtual machine with:

- 4 virtual CPUs
- Approximately 8 GB RAM
- Ollama running as a native systemd service
- Open WebUI running in Docker
- `qwen2.5:3b` and `qwen2.5:7b`

The intended physical target is an older Dell micro-form-factor PC with a 7th-generation Intel Core i5, 16 GB RAM, and a 250 GB SSD.

## Architecture

```text
Browser on LAN
    |
    v
Open WebUI container :3000
    |
    v
Ollama service :11434
    |
    +-- qwen2.5:3b
    +-- qwen2.5:7b
```

## Quick start

Follow [INSTALL.md](INSTALL.md) from top to bottom.

After installation, browse to:

```text
http://SERVER-IP:3000
```

The first Open WebUI account created becomes the administrator.

## Key lesson from the VM build

Ollama initially listened only on `127.0.0.1:11434`, so the Open WebUI Docker container could not connect to it. The persistent systemd override in `systemd/ollama-override.conf` changes Ollama to listen on `0.0.0.0:11434`.

That exposes the Ollama API to the local network unless a firewall restricts it. See the firewall section in [INSTALL.md](INSTALL.md).

## Repository contents

- `INSTALL.md` – complete build checklist
- `TROUBLESHOOTING.md` – common checks and fixes
- `BENCHMARKS.md` – test results and a repeatable benchmark method
- `docker-compose.yml` – reproducible Open WebUI deployment
- `systemd/ollama-override.conf` – Ollama network binding override
- `scripts/verify.sh` – quick health check

## Status

Proof of concept working. Open WebUI successfully discovers both installed Qwen models through Ollama.
