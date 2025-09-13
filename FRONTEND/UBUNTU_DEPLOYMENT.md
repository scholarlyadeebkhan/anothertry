# AarogyaLink Ubuntu Deployment Guide

This guide explains how to deploy the AarogyaLink application on an Ubuntu server.

## Prerequisites

- Ubuntu 18.04 or newer
- Python 3.8 or newer
- pip package manager
- sudo privileges

## Deployment Methods

### Method 1: Quick Deployment Script

1. Make the deployment script executable:
   ```bash
   chmod +x deploy_ubuntu.sh
   ```

2. Run the deployment script as root:
   ```bash
   sudo ./deploy_ubuntu.sh
   ```

3. Follow the on-screen instructions to configure your API keys in `/var/www/aarogyalink/.env`

4. Start the service:
   ```bash
   sudo systemctl start aarogyalink
   ```

### Method 2: Manual Installation

1. Update your system:
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```

2. Install Python and required packages:
   ```bash
   sudo apt install python3 python3-pip python3-venv -y
   ```

3. Create application directory:
   ```bash
   sudo mkdir -p /var/www/aarogyalink
   sudo chown $USER:$USER /var/www/aarogyalink
   ```

4. Copy application files to the directory:
   ```bash
   cp -r * /var/www/aarogyalink/
   ```

5. Create a virtual environment:
   ```bash
   cd /var/www/aarogyalink
   python3 -m venv venv
   source venv/bin/activate
   ```

6. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

7. Configure environment variables:
   Create a `.env` file in `/var/www/aarogyalink/` with your API keys:
   ```bash
   nano .env
   ```
   
   Add your configuration:
   ```
   # Flask Configuration
   SECRET_KEY=your-secret-key-here
   FLASK_ENV=production
   FLASK_DEBUG=False

   # API Keys
   TEACHABLE_API_KEY=your-teachable-api-key-here
   GEMINI_API_KEY=your-gemini-api-key-here

   # File Upload Configuration
   MAX_CONTENT_LENGTH=16777216
   UPLOAD_FOLDER=uploads
   ```

8. Create systemd service:
   ```bash
   sudo cp aarogyalink.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable aarogyalink.service
   ```

9. Start the service:
   ```bash
   sudo systemctl start aarogyalink
   ```

## Managing the Service

- Check service status:
  ```bash
  sudo systemctl status aarogyalink
  ```

- View logs:
  ```bash
  sudo journalctl -u aarogyalink -f
  ```

- Stop the service:
  ```bash
  sudo systemctl stop aarogyalink
  ```

- Restart the service:
  ```bash
  sudo systemctl restart aarogyalink
  ```

## Firewall Configuration

If you have UFW enabled, allow traffic on port 5000:
```bash
sudo ufw allow 5000
```

## Accessing the Application

Once deployed, the application will be available at:
```
http://your-server-ip:5000
```

## Troubleshooting

1. **Service won't start**: Check logs with `sudo journalctl -u aarogyalink -f`

2. **Permission errors**: Ensure the application directory is owned by the correct user

3. **Missing dependencies**: Install with `pip install -r requirements.txt`

4. **API keys not working**: Verify your `.env` file configuration

## Production Considerations

For production deployment, consider:

1. Using a reverse proxy like Nginx (configuration example provided in nginx-aarogyalink.conf)
2. Setting up SSL with Let's Encrypt
3. Using a production WSGI server like Gunicorn (configuration provided in gunicorn.conf.py)
4. Configuring proper backups
5. Setting up monitoring and alerting

### Using Gunicorn with systemd

For better performance and stability in production, you can use the Gunicorn service:

1. Copy the Gunicorn service file:
   ```bash
   sudo cp aarogyalink-gunicorn.service /etc/systemd/system/
   ```

2. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable aarogyalink-gunicorn.service
   sudo systemctl start aarogyalink-gunicorn
   ```

### Using Nginx as Reverse Proxy

1. Install Nginx:
   ```bash
   sudo apt install nginx
   ```

2. Copy the configuration file:
   ```bash
   sudo cp nginx-aarogyalink.conf /etc/nginx/sites-available/aarogyalink
   ```

3. Enable the site:
   ```bash
   sudo ln -s /etc/nginx/sites-available/aarogyalink /etc/nginx/sites-enabled/
   ```

4. Test the configuration:
   ```bash
   sudo nginx -t
   ```

5. Restart Nginx:
   ```bash
   sudo systemctl restart nginx
   ```

## Updating the Application

To update the application:

1. Stop the service:
   ```bash
   sudo systemctl stop aarogyalink
   ```

2. Update files in `/var/www/aarogyalink/`

3. Restart the service:
   ```bash
   sudo systemctl start aarogyalink
   ```