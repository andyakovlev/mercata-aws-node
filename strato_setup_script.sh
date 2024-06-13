#!/bin/bash

# Ask user for mandatory variables
read -p "Enter domain name: " DOMAIN_NAME
read -p "Enter client ID: " CLIENT_ID
read -p "Enter client secret: " CLIENT_SECRET

# Ask user for optional variables
read -p "Enter SendGrid API key (leave blank if not applicable): " SENDGRID_API_KEY
read -p "Enter admin email (leave blank if not applicable): " ADMIN_EMAIL

# Create a reference file
touch ~/_NOTE_all-data-is-in-root-datadrive-folder

# Navigate to the /datadrive directory
cd /datadrive || exit

# Clone the strato-getting-started repository
git clone https://github.com/blockapps/strato-getting-started
cd strato-getting-started || exit

# Download docker-compose.yml of the latest release version
sudo ./strato --compose

# Pull necessary Docker images
sudo ./strato --pull

# Create or update strato-run.sh with variables
cat <<EOF >strato-run.sh
#!/bin/bash

NODE_HOST="$DOMAIN_NAME" \
  BOOT_NODE_IP='["44.209.149.47","54.84.33.40","52.1.78.10","44.198.14.117"]' \
  networkID="6909499098523985262" \
  OAUTH_CLIENT_ID="$CLIENT_ID" \
  OAUTH_CLIENT_SECRET="$CLIENT_SECRET" \
  SENDGRID_API_KEY="$SENDGRID_API_KEY" \
  ADMIN_EMAIL="$ADMIN_EMAIL" \
  ./strato
EOF

# Make strato-run.sh executable
sudo chmod +x strato-run.sh

# Run the STRATO
sudo ./strato-run.sh
