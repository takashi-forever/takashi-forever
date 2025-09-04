#!/bin/bash
set -e

# ---------------------------
# Update system & install dependencies
# ---------------------------
sudo apt update -y
sudo apt install -y build-essential wget curl git unzip zip neofetch make g++ imagemagick webp ffmpeg python3-pip speedtest-cli pkg-config libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev librsvg2-dev

# ---------------------------
# Install NVM if not installed
# ---------------------------
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  echo "Installing NVM..."
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi
source "$NVM_DIR/nvm.sh"

# ---------------------------
# Install Node.js v20
# ---------------------------
NODE_VERSION="20"
if ! nvm ls $NODE_VERSION &> /dev/null; then
  echo "Installing Node.js v$NODE_VERSION..."
  nvm install $NODE_VERSION
fi
nvm use $NODE_VERSION
nvm alias default $NODE_VERSION

# ---------------------------
# Install global npm packages
# ---------------------------
npm install -g node-gyp pm2

# ---------------------------
# Install or update yt-dlp
# ---------------------------
YTDLP_BIN="/usr/local/bin/yt-dlp"
if [ -f "$YTDLP_BIN" ]; then
  echo "Updating yt-dlp..."
  sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $YTDLP_BIN
else
  echo "Installing yt-dlp..."
  sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $YTDLP_BIN
fi
sudo chmod a+rx $YTDLP_BIN

# ---------------------------
# Change to bot directory
# ---------------------------
BOT_DIR="/home/tenka/botku"
if [ ! -d "$BOT_DIR" ]; then
  echo "Error: Bot directory $BOT_DIR does not exist!"
  exit 1
fi
cd $BOT_DIR

# ---------------------------
# Install npm dependencies
# ---------------------------
echo "Installing npm dependencies..."
npm install

# ---------------------------
# Start or restart bot with PM2
# ---------------------------
BOT_NAME="botku"
ENTRY_FILE="index.js"  # Ganti sesuai nama file utama botmu
if pm2 list | grep -q "$BOT_NAME"; then
  echo "Restarting existing PM2 process..."
  pm2 restart $BOT_NAME
else
  echo "Starting bot with PM2..."
  pm2 start $ENTRY_FILE --name $BOT_NAME
fi

# ---------------------------
# Show system info
# ---------------------------
neofetch

echo "Setup complete!"
