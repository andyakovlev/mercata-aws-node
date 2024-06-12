#!/bin/bash

# This script handles both installation and volume mounting
# Usage:
#   sudo bash master_script.sh install  # To install software and configure Docker
#   sudo bash master_script.sh mount    # To mount the volume and configure Docker storage

set -e
set -x

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo >&2 "Must be run as root"
        exit 1
    fi
}

install_software() {
    sudo yum update -y
    sudo yum install -y docker git htop jq ncdu-1.10-1.3.amzn1.x86_64.rpm

    # Autostart on reboot
    sudo systemctl enable docker
    sudo systemctl start docker

    # Docker-compose
    sudo mkdir -p /usr/local/lib/docker/cli-plugins/
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    sudo wget http://packages.eu-central-1.amazonaws.com/2018.03/main/c31535f74c6e/x86_64/Packages/ncdu-1.10-1.3.amzn1.x86_64.rpm
    sudo yum install -y ncdu-1.10-1.3.amzn1.x86_64.rpm
}

mount_volume() {
    # Mount volume to /datadrive dir with auto-mount
    lsblk
    sudo file -s /dev/nvme1n1
    sudo mkfs -t xfs /dev/nvme1n1
    sudo mkdir /datadrive
    sudo chmod 777 /datadrive/
    sudo mount /dev/nvme1n1 /datadrive/
    sudo cp /etc/fstab /etc/fstab.orig
    sudo bash -c "echo 'UUID=$(sudo blkid | grep nvme1n1 | cut -d\" -f2)  /datadrive  xfs  defaults,nofail  0  2'>> /etc/fstab"
    sudo umount /datadrive && sudo mount -a
    sudo chown ec2-user /datadrive/
    df -h

    # Move Docker to the data volume
    sudo service docker stop
    sudo bash -c "echo '{\"data-root\": \"/datadrive/docker\"}' > /etc/docker/daemon.json"
    sudo rsync -aP /var/lib/docker/ /datadrive/docker
    sudo rm -rf /var/lib/docker
    sudo service docker start
}

case "$1" in
    install)
        check_root
        install_software
        ;;
    mount)
        check_root
        mount_volume
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: $0 {install|mount}"
        exit 1
        ;;
esac
