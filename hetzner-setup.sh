#!/bin/bash
set -e

echo "🚀 Setting up n8n on Hetzner Cloud..."

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl enable docker
systemctl start docker

# Install snap and certbot
echo "🔐 Installing SSL certificate tools..."
apt install snapd -y
snap install core
snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

# Configure firewall
echo "🔥 Configuring firewall..."
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable

# Create project directories
echo "📁 Creating project structure..."
mkdir -p /opt/n8n /opt/scripts /opt/backups/n8n
cd /opt/n8n

# Generate encryption key
echo "🔑 Generating encryption key..."
ENCRYPTION_KEY=$(openssl rand -hex 16)
echo "Generated encryption key: $ENCRYPTION_KEY"

echo "✅ Server setup complete!"
echo "Next steps:"
echo "1. Create docker-compose.yml file"
echo "2. Create .env file with encryption key: $ENCRYPTION_KEY"
echo "3. Run SSL setup and start n8n" 