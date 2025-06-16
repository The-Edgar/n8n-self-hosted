# n8n Self-Hosted Deployment on Hetzner Cloud

## Overview

This project provides a **production-ready, secure, and scalable deployment** of [n8n](https://n8n.io/) (an open-source workflow automation tool) on a Hetzner Cloud VPS, using Docker Compose and Caddy for automatic HTTPS.

---

## Features

- **One-click deployment** with Docker Compose
- **Automatic HTTPS** via Caddy and Let's Encrypt
- **Persistent storage** for workflows and credentials (SQLite by default)
- **Secure authentication** (Basic Auth enabled)
- **Automated backups** (optional script included)
- **Best practices** for security, scalability, and maintainability

---

## Prerequisites

- A Hetzner Cloud account and a running Ubuntu 24.04 server (CX22 or better recommended)
- A domain name (e.g., `n8n.[DOMAIN.COM]`) pointed to your server's public IP
- [1Password](https://1password.com/) or another SSH key manager for secure, passwordless server access
- [Docker](https://docs.docker.com/engine/install/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) installed (see below for automated setup)

---

## Quick Start

### 1. **Provision Your Hetzner Server**

- Create a new Ubuntu 24.04 server in the Hetzner Cloud Console.
- Add your SSH public key during server creation for secure, passwordless access.
- Note your server's public IP address.

### 2. **Configure DNS**

- Add an `A` record for your subdomain (e.g., `n8n.[DOMAIN.COM]`) pointing to your Hetzner server's IP.

### 3. **SSH Into Your Server**

```bash
ssh root@your-server-ip
# Or, if using 1Password SSH agent:
ssh hetzner
```

### 4. **Clone or Upload Project Files**

Copy the following files to `/opt/n8n` on your server:
- `docker-compose.yml`
- `Caddyfile`
- `.env` (see below, create this yourself; it is not tracked in git)
- `backup-n8n.sh` (optional, for backups)
- `hetzner-setup.sh` (optional, for initial server setup)
- `workflow-templates/` (optional, for sharing n8n workflow templates)

### 5. **Set Up Environment Variables**

Create `/opt/n8n/.env` with at least:

```env
N8N_ENCRYPTION_KEY=your_generated_key
N8N_BASIC_AUTH_USER=youruser
N8N_BASIC_AUTH_PASSWORD=yourpassword
N8N_HOST=n8n.[DOMAIN.COM]
N8N_PORT=5678
N8N_PROTOCOL=http
DB_TYPE=sqlite
```

Generate a strong encryption key with:
```bash
openssl rand -hex 16
```

**Note:** `.env` is not tracked in git and must be created by you on the server.

### 6. **Deploy with Docker Compose**

```bash
cd /opt/n8n
docker compose up -d
```

### 7. **Access n8n**

Visit [https://n8n.[DOMAIN.COM]](https://n8n.[DOMAIN.COM]) in your browser.  
Login with the credentials from your `.env` file.

---

## File Structure

```
/opt/n8n/
  ├── docker-compose.yml
  ├── Caddyfile
  ├── .env (not tracked in git)
  ├── backup-n8n.sh (optional)
  ├── hetzner-setup.sh (optional)
  └── workflow-templates/ (optional)
```

---

## SSH Key Management

- **Best Practice:** Use SSH keys for all server access.  
- **1Password SSH Agent:**  
  - Store your private key in 1Password.
  - Add your public key to Hetzner during server creation.
  - Use `ssh-add` or 1Password's built-in agent for passwordless login.
- **Never share or expose your private key.**

---

## OAuth Requirements for n8n Self-Hosting

- **Public URL:** Your n8n instance must be accessible via HTTPS on a public domain (e.g., `https://n8n.[DOMAIN.COM]`).
- **Redirect URI:** For OAuth2 credentials, use:
  ```
  https://n8n.[DOMAIN.COM]/rest/oauth2-credential/callback
  ```
- **No port in public URI:** Do not include `:5678` or use `http://` in your OAuth app settings.
- **Update provider settings:** Set the above redirect URI in your OAuth provider's developer console (Google, LinkedIn, etc.).
- **Restart n8n after changes:** If you update `.env` or credentials, restart the containers:
  ```bash
  docker compose restart
  ```

---

## Backups

- Use the provided `backup-n8n.sh` script to back up your SQLite database and n8n data.
- Schedule with cron for daily backups:
  ```bash
  crontab -e
  # Add:
  0 2 * * * /opt/scripts/backup-n8n.sh
  ```

---

## Security Best Practices

- Use strong, unique passwords for Basic Auth.
- Keep your server and Docker images up to date.
- Restrict SSH access to trusted IPs if possible.
- Enable UFW and allow only ports 22 (SSH), 80, and 443.

---

## Troubleshooting

- **SSL Issues:** Check Caddy logs with `docker compose logs caddy`.
- **n8n Not Starting:** Check n8n logs with `docker compose logs n8n`.
- **OAuth Errors:** Double-check your redirect URI and that your instance is accessible via HTTPS.

---

## Scaling & Production Notes

- For teams or high reliability, consider switching to PostgreSQL (see n8n docs).
- For advanced reverse proxy or custom SSL, adjust the Caddyfile as needed.

---

## References

- [n8n Documentation](https://docs.n8n.io/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Caddy Docs](https://caddyserver.com/docs/)
- [Hetzner Cloud Docs](https://docs.hetzner.com/cloud/)

---

## License

MIT or as per n8n's open-source license.

---

**Questions or issues?**  
Open an issue or contact your deployment maintainer. 