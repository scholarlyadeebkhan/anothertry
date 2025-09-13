#!/bin/bash

# Simple startup script for AarogyaLink on Ubuntu (development/testing)

# Make script executable
chmod +x "$0" 2>/dev/null || true

# Ensure we have execute permissions
chmod +x deploy_ubuntu.sh 2>/dev/null || true
chmod +x start.sh 2>/dev/null || true

echo "Starting AarogyaLink on Ubuntu..."

# Check if we're on Ubuntu/Debian
if ! command -v lsb_release &> /dev/null; then
    echo "This script is designed for Ubuntu/Debian systems."
    echo "Attempting to continue anyway..."
fi

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is required but not found."
    echo "Please install Python 3 and try again."
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Install requirements
    echo "Installing Python requirements..."
    pip install -r requirements.txt
else
    # Activate virtual environment
    source venv/bin/activate
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "WARNING: .env file not found!"
    echo "Please create .env file with your API keys"
    echo "See .env.example for reference"
fi

echo "Starting AarogyaLink server..."
echo "The application will be available at http://localhost:5000"
echo "Press Ctrl+C to stop the server"

# Run the application
python3 run.py