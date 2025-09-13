#!/bin/bash

# AarogyaLink Startup Script for Ubuntu

# Make script executable
chmod +x "$0" 2>/dev/null || true

# Check if we're running on Ubuntu
if ! grep -q Ubuntu /etc/os-release; then
    echo "This script is designed for Ubuntu systems."
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Installing..."
    sudo apt update
    sudo apt install -y python3 python3-pip
fi

# Check if virtual environment exists, if not create it
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install requirements
echo "Installing requirements..."
pip install -r requirements.txt

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "WARNING: .env file not found!"
    echo "Please create .env file with your API keys"
    echo "See .env.example for reference"
fi

# Start the Flask server
echo "Starting AarogyaLink server..."
echo "Server will be available at http://localhost:5000"
echo "Press Ctrl+C to stop the server"

python run.py