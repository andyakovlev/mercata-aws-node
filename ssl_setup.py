import subprocess
import sys
import string
import random

def generate_random_subdomain(length=5):
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=length))

def provision_certificate(domain, email):
    # Generate a random subdomain
    subdomain = generate_random_subdomain()
    full_domain = f"{subdomain}.{domain}"

    # Prepare the Certbot command to obtain a certificate
    command = [
        'sudo', 'certbot', 'certonly', '--standalone',
        '--preferred-challenges', 'http',
        '--agree-tos', '--email', email,
        '-d', domain, '-d', full_domain
    ]
    
    # Execute the command to get the certificate
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    # Check the result of certificate provisioning
    if result.returncode == 0:
        print("Certificate provisioned successfully.")
        print(result.stdout)

        # Paths where Certbot saves the certificate and key
        cert_path = f'/etc/letsencrypt/live/{domain}/fullchain.pem'
        key_path = f'/etc/letsencrypt/live/{domain}/privkey.pem'

        # Target paths for copying the certificate and key
        target_cert_path = '/datadrive/strato-getting-started/ssl/certs/server.pem'
        target_key_path = '/datadrive/strato-getting-started/ssl/private/server.key'

        # Copy the certificate and key to the specified paths
        copy_cert_command = ['sudo', 'cp', cert_path, target_cert_path]
        copy_key_command = ['sudo', 'cp', key_path, target_key_path]

        # Execute copy commands
        subprocess.run(copy_cert_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        subprocess.run(copy_key_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        print(f"Certificate copied to {target_cert_path}")
        print(f"Key copied to {target_key_path}")

    else:
        print("Failed to provision certificate.")
        print(result.stderr)

if __name__ == "__main__":
    # Ensure the script is called with the correct number of arguments
    if len(sys.argv) != 3:
        print("Usage: sudo python3 script.py <domain> <email>")
        sys.exit(1)
    
    domain = sys.argv[1]
    email = sys.argv[2]
    
    # Call the function to provision the certificate and copy files
    provision_certificate(domain, email)
