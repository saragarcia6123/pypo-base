#!/bin/bash

# Usage example:
# ./scripts/gen_openssl_env_var.sh "FLASK_SECRET_KEY"

if ! command -v openssl &> /dev/null; then
    echo "openssl is not installed. Please install it to proceed."
    exit 1
fi

# Check if .env already exists and create if not
if [ ! -f .env ]; then
    echo "No .env file found. Creating one..."
    touch .env
    echo "Created .env file"
fi

# Extract the key from the first argument
KEY=$1

if [ -z "$KEY" ]; then
    echo "Error: No key provided."
    exit 1
fi

# Generate the value using OpenSSL
VALUE=$(openssl rand -base64 32)
echo "Generated value using OpenSSL"

set_environment_variable() {
    local key=$1
    local value
    local escaped_value

    # Escape special characters
    escaped_value=$(printf '%s' "$value" | sed 's/[&/\]/\\&/g')

    echo "${key}=${escaped_value}" >> .env
}

# Set the keys as environment variables
set_environment_variable "${KEY}" "${VALUE}"

echo "Environment variable ${KEY} generated and set successfully."