#!/bin/bash

# Ask user for mandatory variables
read -p "Enter email name: " ADMIN_EMAIL
read -p "Enter domain name: " DOMAIN_NAME
read -p "Enter client ID: " CLIENT_ID
read -p "Enter client secret: " CLIENT_SECRET

# Ask user for optional variables
read -p "Enter SendGrid API key (leave blank if not applicable): " SENDGRID_API_KEY

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
  ssl=true \
  accountNonceLimit=2000 \
  creatorForkBlockNumber=6200 \
  BASE_CODE_COLLECTION=d979d67877db869f18283e93ea4bf2d256df92d2 \
  ./strato
EOF

# Set up SSL
sudo python3 /tmp/mercata-aws-node/ssl_setup.py "$DOMAIN_NAME" "$ADMIN_EMAIL"

# Make strato-run.sh executable
sudo chmod +x strato-run.sh

# Run the STRATO
sudo ./strato-run.sh
