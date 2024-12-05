#!/bin/bash

cert_path="ssl_certificate"

# Generate SSL certificate and key if not present
if [ ! -d "$cert_path" ]; then
    mkdir "$cert_path"
    echo "Created ${cert_path} directory"
fi

if [ -f "$cert_path/key.pem" ] && [ -f "$cert_path/cert.pem" ]; then
    read -r -p "SSL certificate and key already exist. Do you want to overwrite them? (y/n): " choice
    choice=${choice:-n}  # Default to "n" if no input
    case "$choice" in
        y|Y ) echo "Overwriting SSL certificate and key...";;
        * ) echo "Skipping SSL certificate and key generation"; exit 0;;
    esac
fi

echo "Generating self-signed SSL certificate and key..."

openssl genpkey -algorithm RSA -out "${cert_path}/key.pem"
openssl req -new -x509 -key "${cert_path}/key.pem" -out "${cert_path}/cert.pem" -days 365 \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

echo "SSL certificate and key generated successfully."

# Add SSL certificate and key to environment variables
echo "SSL_CERT_FILE=${cert_path}/cert.pem" >> .env
echo "SSL_KEY_FILE=${cert_path}/key.pem" >> .env

echo "SSL certificate and key added to .env file"

# Add certificate to trusted store if update-ca-trust is available
if command -v update-ca-trust &> /dev/null; then
    sudo cp "${cert_path}/cert.pem" /etc/pki/ca-trust/source/anchors/localhost.crt
    sudo update-ca-trust
    echo "Self-signed SSL certificate added to the trusted store."
else
    echo "update-ca-trust command not found. Please install it to add the certificate to the trusted store."
fi
