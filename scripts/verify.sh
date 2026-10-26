#!/usr/bin/env bash
set -u

pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; }

if systemctl is-active --quiet ollama; then
  pass 'Ollama service is active'
else
  fail 'Ollama service is not active'
fi

if ss -tln 2>/dev/null | grep -q ':11434'; then
  pass 'Port 11434 is listening'
else
  fail 'Port 11434 is not listening'
fi

if curl -fsS http://localhost:11434/api/tags >/dev/null; then
  pass 'Ollama API responds'
else
  fail 'Ollama API does not respond'
fi

if docker inspect -f '{{.State.Health.Status}}' open-webui 2>/dev/null | grep -q healthy; then
  pass 'Open WebUI container is healthy'
else
  fail 'Open WebUI container is absent or unhealthy'
fi

if curl -fsS http://localhost:3000 >/dev/null; then
  pass 'Open WebUI responds on port 3000'
else
  fail 'Open WebUI does not respond on port 3000'
fi
