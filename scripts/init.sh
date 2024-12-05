#!/bin/bash

# This file is intended to be run ONCE after cloning the original pypo-base repository.
# It sets up the project environment, including the .env file, virtual environment, and project namespace directory.

if grep -q "FIRST_RUN=false" .env; then
    echo "The project is already set up. Would you like to reset it (PROCEED WITH CAUTION!!)? (y/n): "
    read -r choice
    if [ "$choice" != "y" ]; then
        exit 1
    fi
fi

# Set up the .env file
./scripts/create_dotenv.sh

# Set first run flag in .env
grep -q "FIRST_RUN=" .env && sed -i 's/FIRST_RUN=.*/FIRST_RUN=true/' .env || echo "FIRST_RUN=true" >> .env

# Generate a one-time SSL certificate and key
./scripts/gen_ssl_certificate.sh

# Set up the virtual environment
source ./scripts/setup_venv.sh

# Install dependencies
pip install poetry || { echo "Poetry installation failed."; exit 1; }
poetry init

# Extract the project name from pyproject.toml
PROJECT_NAME=$(grep -oP '(?<=name = ").*(?=")' pyproject.toml)

# Handle missing project name
if [ -z "$PROJECT_NAME" ]; then
    echo "Error: Project name not found in pyproject.toml."
    exit 1
fi

# Set the package name
PACKAGE_NAME=$(echo "$PROJECT_NAME" | tr '-' '_')
echo 'PACKAGE_NAME='"$PACKAGE_NAME" >> .env

# Set the project root directory
PROJECT_ROOT=$(pwd)/src/$PACKAGE_NAME
echo 'PROJECT_ROOT='"$PROJECT_ROOT" >> .env

# Create the project namespace directory
mkdir -p "$PROJECT_ROOT"
touch "$PROJECT_ROOT/__init__.py"

# Create the tests namespace directory
mkdir -p "$(pwd)/tests/$PACKAGE_NAME"
touch "$(pwd)/tests/$PACKAGE_NAME/__init__.py"

# Add the src folder to PYTHONPATH to enable custom module imports
export PYTHONPATH="$PROJECT_ROOT:$PYTHONPATH"

# Unset the first run flag
grep -q "FIRST_RUN=" .env && sed -i 's/FIRST_RUN=.*/FIRST_RUN=false/' .env || echo "FIRST_RUN=false" >> .env

echo "Project namespace directory 'src/$PACKAGE_NAME' created successfully."
