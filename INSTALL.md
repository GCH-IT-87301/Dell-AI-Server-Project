# Installation Checklist

## 1. Install Ubuntu Server

Install Ubuntu Server 24.04 LTS on the Dell. During setup:

- Enable OpenSSH.
- Use Ethernet if available.
- Record the server IP address.

After first login:

```bash
sudo apt update
sudo apt upgrade -y
sudo reboot
```

Reconnect over SSH after the reboot.

## 2. Install basic tools

```bash
sudo apt install -y curl git htop
```

## 3. Install Docker

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"
```

Log out and reconnect so the group change takes effect, then verify:

```bash
docker --version
docker ps
```

`docker ps` should work without `sudo`.

## 4. Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Verify the service:

```bash
systemctl status ollama --no-pager
```

## 5. Allow the Open WebUI container to reach Ollama

Create a systemd override:

```bash
sudo systemctl edit ollama
```

Enter exactly:

```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
```

Save and exit, then apply it:

```bash
sudo systemctl daemon-reload
sudo systemctl restart ollama
sudo ss -tlnp | grep 11434
```

Expected listening address:

```text
*:11434
```

If it still shows `127.0.0.1:11434`, review the override with:

```bash
sudo systemctl cat ollama
```

### Firewall note

Binding Ollama to `0.0.0.0` makes port 11434 reachable beyond localhost. If UFW is enabled, allow the WebUI port from the LAN and do not broadly expose Ollama unless needed.

Example for a `192.168.1.0/24` LAN:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 3000 proto tcp
sudo ufw deny 11434/tcp
```

Docker reaches Ollama through the host bridge, so verify firewall behavior after applying rules. Adjust the subnet to match the actual network.

## 6. Download models

```bash
ollama pull qwen2.5:3b
ollama pull qwen2.5:7b
ollama list
```

Test one directly:

```bash
ollama run qwen2.5:3b "Explain in one paragraph how reusing old computers reduces e-waste."
```

## 7. Start Open WebUI

From this repository directory:

```bash
docker compose up -d
```

Verify:

```bash
docker ps
```

The `open-webui` container should eventually show `healthy`.

## 8. Open the web interface

From another computer on the LAN, visit:

```text
http://SERVER-IP:3000
```

Create the first account, which becomes the Open WebUI administrator. Confirm that both Qwen models appear in the model selector.

## 9. Run the health check

```bash
chmod +x scripts/verify.sh
./scripts/verify.sh
```

## 10. Reboot test

```bash
sudo reboot
```

After reconnecting:

```bash
systemctl is-active ollama
docker ps
curl -s http://localhost:11434/api/tags
```

Both Ollama and Open WebUI should return automatically.
