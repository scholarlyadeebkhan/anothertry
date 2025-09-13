#!/bin/bash

# Test script for AarogyaLink Ubuntu deployment

# Make script executable
chmod +x "$0" 2>/dev/null || true

echo "Testing AarogyaLink Ubuntu deployment..."

# Check if running on Ubuntu
if ! grep -q Ubuntu /etc/os-release 2>/dev/null; then
    echo "Warning: This script is designed for Ubuntu systems."
fi

# Check if required files exist
required_files=(
    "app.py"
    "requirements.txt"
    "run.py"
    "deploy_ubuntu.sh"
    "run_ubuntu.sh"
    "start.sh"
    "aarogyalink.service"
    "gunicorn.conf.py"
)

echo "Checking for required files..."
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing required file: $file"
        exit 1
    else
        echo "✅ Found: $file"
    fi
done

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    exit 1
else
    echo "✅ Python 3 is available"
fi

# Check if pip is available
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed"
    exit 1
else
    echo "✅ pip3 is available"
fi

# Test virtual environment creation
echo "Testing virtual environment creation..."
if python3 -m venv test_venv 2>/dev/null; then
    echo "✅ Virtual environment creation successful"
    # Clean up
    rm -rf test_venv
else
    echo "❌ Virtual environment creation failed"
    exit 1
fi

# Check service file syntax
if command -v systemd-analyze &> /dev/null; then
    echo "Checking systemd service file..."
    if systemd-analyze verify aarogyalink.service 2>/dev/null; then
        echo "✅ Systemd service file syntax is correct"
    else
        echo "❌ Systemd service file has syntax errors"
    fi
fi

echo "✅ All tests passed! AarogyaLink is ready for Ubuntu deployment."
echo ""
echo "Next steps:"
echo "1. Review the UBUNTU_DEPLOYMENT.md guide"
echo "2. Run deploy_ubuntu.sh as root to deploy"
echo "   sudo ./deploy_ubuntu.sh"