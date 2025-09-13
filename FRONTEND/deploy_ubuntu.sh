#!/bin/bash

# AarogyaLink Ubuntu Deployment Script
# This script installs and configures AarogyaLink on Ubuntu

# Make script executable
chmod +x "$0" 2>/dev/null || true

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  AarogyaLink Ubuntu Deployment ${NC}"
echo -e "${GREEN}================================${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (sudo)${NC}"
  exit 1
fi

# Update package list
echo -e "${YELLOW}Updating package list...${NC}"
apt update

# Install Python and pip if not already installed
echo -e "${YELLOW}Installing Python and pip...${NC}"
apt install -y python3 python3-pip python3-venv

# Create application directory
echo -e "${YELLOW}Creating application directory...${NC}"
mkdir -p /var/www/aarogyalink
cd /var/www/aarogyalink

# Copy application files (assuming they're in the current directory)
echo -e "${YELLOW}Copying application files...${NC}"
cp -r ./* /var/www/aarogyalink/

# Set proper permissions
echo -e "${YELLOW}Setting permissions...${NC}"
chown -R www-data:www-data /var/www/aarogyalink
chmod +x /var/www/aarogyalink/run.py

# Create virtual environment
echo -e "${YELLOW}Creating virtual environment...${NC}"
python3 -m venv /var/www/aarogyalink/venv
source /var/www/aarogyalink/venv/bin/activate

# Install requirements
echo -e "${YELLOW}Installing Python requirements...${NC}"
pip install -r /var/www/aarogyalink/requirements.txt

# Create .env file if it doesn't exist
if [ ! -f /var/www/aarogyalink/.env ]; then
  echo -e "${YELLOW}Creating .env file...${NC}"
  cat > /var/www/aarogyalink/.env << EOF
# AarogyaLink Backend Configuration

# Flask Configuration
SECRET_KEY=$(openssl rand -hex 32)
FLASK_ENV=production
FLASK_DEBUG=False

# API Keys - Replace with your actual API keys
TEACHABLE_API_KEY=your-teachable-api-key-here
GEMINI_API_KEY=your-gemini-api-key-here

# Teachable API Configuration
TEACHABLE_BASE_URL=https://api.teachable.com/v1

# File Upload Configuration
MAX_CONTENT_LENGTH=16777216
UPLOAD_FOLDER=uploads

# Logging Configuration
LOG_LEVEL=INFO
EOF
fi

# Create uploads directory
mkdir -p /var/www/aarogyalink/uploads
chown -R www-data:www-data /var/www/aarogyalink/uploads

# Install systemd service
echo -e "${YELLOW}Installing systemd service...${NC}"
cp /var/www/aarogyalink/aarogyalink.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable aarogyalink.service

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Edit /var/www/aarogyalink/.env and add your API keys"
echo -e "2. Start the service: sudo systemctl start aarogyalink"
echo -e "3. Check status: sudo systemctl status aarogyalink"
echo -e "4. View logs: sudo journalctl -u aarogyalink -f"
echo -e ""
echo -e "The application will be available at http://your-server-ip:5000"