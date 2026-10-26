# Troubleshooting

## Open WebUI loads but shows no models

Confirm Ollama has models:

```bash
curl -s http://localhost:11434/api/tags
ollama list
```

Confirm Ollama is not restricted to localhost:

```bash
sudo ss -tlnp | grep 11434
```

Expected:

```text
*:11434
```

Check the systemd configuration:

```bash
sudo systemctl cat ollama
```

Check Open WebUI logs:

```bash
docker logs --tail 100 open-webui
```

A connection failure involving `host.docker.internal` or `172.17.0.1:11434` usually means Ollama is still listening only on `127.0.0.1` or a firewall is blocking the Docker bridge.

## Docker permission denied

Symptom:

```text
permission denied while trying to connect to the Docker API at unix:///var/run/docker.sock
```

Fix:

```bash
sudo usermod -aG docker "$USER"
```

Log out completely and reconnect, then run:

```bash
docker ps
```

## Check all major components

```bash
systemctl is-active ollama
sudo ss -tlnp | grep 11434
docker ps
curl -s http://localhost:11434/api/tags
curl -I http://localhost:3000
```

## Watch activity while generating

```bash
htop
```

Ollama service logs:

```bash
journalctl -fu ollama
```

Open WebUI logs:

```bash
docker logs -f open-webui
```

Loaded model state:

```bash
watch -n 1 ollama ps
```

## Restart components

```bash
sudo systemctl restart ollama
docker restart open-webui
```

## Stop or remove Open WebUI

Stop while preserving data:

```bash
docker compose down
```

Remove the persistent WebUI volume too:

```bash
docker compose down -v
```

The second command deletes Open WebUI accounts, settings, and chat history stored in the Docker volume.
