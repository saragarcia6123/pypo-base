#!/bin/bash

# Install pipreqs and poetry if they are not installed
if ! command -v pipreqs &> /dev/null; then
    echo "Installing pipreqs..."
    pip install --upgrade pip  # Ensure pip is up-to-date
    pip install pipreqs
fi

if ! command -v poetry &> /dev/null; then
    echo "Installing poetry..."
    pip install poetry
fi

# Generate requirements.txt and add dependencies using poetry
pipreqs --force .
poetry add "$(cat requirements.txt)"

# Remove requirements.txt
rm requirements.txt

# Install dependencies
poetry install

# Verify dependencies
poetry check
