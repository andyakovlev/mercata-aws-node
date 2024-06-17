#!/bin/bash

# Ask user for mandatory variables

read -p "Enter domain name: " DOMAIN_NAME
read -p "Enter client ID: " CLIENT_ID
read -p "Enter client secret: " CLIENT_SECRET

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

NODE_HOST="$DOMAIN_NAME" \\
BOOT_NODE_IP='["44.209.149.47","54.84.33.40","52.1.78.10","44.198.14.117"]' \\
networkID="6909499098523985262" \\
OAUTH_CLIENT_ID="$CLIENT_ID" \\
OAUTH_CLIENT_SECRET="$CLIENT_SECRET" \\
ssl=true \\
accountNonceLimit=2000 \\
creatorForkBlockNumber=6200 \\
BASE_CODE_COLLECTION=d979d67877db869f18283e93ea4bf2d256df92d2 \\
./strato
EOF


# Make strato-run.sh executable
sudo chmod +x strato-run.sh
