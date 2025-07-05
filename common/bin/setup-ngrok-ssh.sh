#!/bin/bash

# Script to set up ngrok SSH tunnel on different platforms

set -e

echo "🔧 Ngrok SSH Tunnel Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "📍 Detected OS: $OS"

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok is not installed"
    echo ""
    echo "Install it with:"
    case "$OS" in
        macos)
            echo "  brew install ngrok/ngrok/ngrok"
            ;;
        linux)
            echo "  snap install ngrok"
            echo "  OR"
            echo "  Download from https://ngrok.com/download"
            ;;
    esac
    exit 1
fi

echo "✅ ngrok is installed"

# Check if authtoken is set
if ! ngrok config check &>/dev/null; then
    echo "❌ ngrok authtoken not configured"
    echo "Run: ngrok config add-authtoken YOUR_TOKEN"
    exit 1
fi

echo "✅ ngrok authtoken is configured"

case "$OS" in
    macos)
        echo ""
        echo "🍎 Setting up macOS (launchd)..."
        
        PLIST_PATH="$HOME/Library/LaunchAgents/com.ngrok.ssh.plist"
        
        # Create LaunchAgents directory if it doesn't exist
        mkdir -p "$HOME/Library/LaunchAgents"
        
        # Create plist file
        cat > "$PLIST_PATH" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ngrok.ssh</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/ngrok</string>
        <string>tcp</string>
        <string>22</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
        <key>Crashed</key>
        <true/>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/USER/Library/Logs/ngrok-ssh.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/USER/Library/Logs/ngrok-ssh-error.log</string>
</dict>
</plist>
EOF
        
        # Replace USER with actual username and ngrok path
        sed -i '' "s|/Users/USER|$HOME|g" "$PLIST_PATH"
        NGROK_PATH=$(which ngrok)
        sed -i '' "s|/opt/homebrew/bin/ngrok|$NGROK_PATH|g" "$PLIST_PATH"
        
        echo "✅ Created $PLIST_PATH"
        
        # Load the service
        launchctl unload "$PLIST_PATH" 2>/dev/null || true
        launchctl load "$PLIST_PATH"
        
        echo "✅ Service loaded"
        echo ""
        echo "Commands:"
        echo "  Start:   launchctl load $PLIST_PATH"
        echo "  Stop:    launchctl unload $PLIST_PATH"
        echo "  Status:  launchctl list | grep ngrok"
        ;;
        
    linux)
        echo ""
        echo "🐧 Setting up Linux (systemd)..."
        
        SERVICE_PATH="/etc/systemd/system/ngrok-ssh@.service"
        
        # Create systemd service file
        sudo tee "$SERVICE_PATH" > /dev/null << 'EOF'
[Unit]
Description=Ngrok SSH Tunnel for %i
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/ngrok tcp 22
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=ngrok-ssh
User=%i

[Install]
WantedBy=multi-user.target
EOF
        
        # Update ngrok path
        NGROK_PATH=$(which ngrok)
        sudo sed -i "s|/usr/local/bin/ngrok|$NGROK_PATH|g" "$SERVICE_PATH"
        
        echo "✅ Created $SERVICE_PATH"
        
        # Reload systemd and enable service
        sudo systemctl daemon-reload
        sudo systemctl enable "ngrok-ssh@$USER"
        sudo systemctl start "ngrok-ssh@$USER"
        
        echo "✅ Service enabled and started"
        echo ""
        echo "Commands:"
        echo "  Start:   sudo systemctl start ngrok-ssh@$USER"
        echo "  Stop:    sudo systemctl stop ngrok-ssh@$USER"
        echo "  Status:  sudo systemctl status ngrok-ssh@$USER"
        echo "  Logs:    sudo journalctl -u ngrok-ssh@$USER -f"
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup complete!"
echo ""
echo "Check connection info with: ssh-info"
echo "(Make sure ssh-info is in your PATH)"