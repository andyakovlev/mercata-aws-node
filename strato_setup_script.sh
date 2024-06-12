#!/bin/bash

# Usage: ./setup_strato.sh DOMAIN_NAME CLIENT_ID CLIENT_SECRET [SENDGRID_API_KEY] [ADMIN_EMAIL]

# Check for minimum number of arguments
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 DOMAIN_NAME CLIENT_ID CLIENT_SECRET [SENDGRID_API_KEY] [ADMIN_EMAIL]"
  exit 1
fi

# Assign mandatory arguments to variables
DOMAIN_NAME=$1
CLIENT_ID=$2
CLIENT_SECRET=$3

# Assign optional arguments to variables, use default empty values if not provided
SENDGRID_API_KEY=${4:-''}
ADMIN_EMAIL=${5:-''}

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
  ssl=true \
  ADMIN_EMAIL="$ADMIN_EMAIL" \
  ./strato
EOF

# Make strato-run.sh executable
sudo chmod +x strato-run.sh

# Run the STRATO
sudo ./strato-run.sh
