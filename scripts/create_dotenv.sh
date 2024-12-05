#!/bin/bash

# Check if .env already exists
if [ -f .env ]; then
    read -r -p ".env file already exists. Do you want to overwrite it? (y/n): " choice
    case "$choice" in
        y|Y ) echo "Overwriting .env file..." && rm .env ;;
        * ) exit 1;;
    esac
fi

touch .env
echo "Created .env file"