#!/bin/bash

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Please install it to proceed."
    exit 1
fi

# Check if venv module is installed
if ! python3 -m venv --help &> /dev/null; then
    echo "venv module is not installed. Please install it to proceed."
    exit 1
fi

if [ -d "venv" ]; then
    read -r -p "The virtual environment is already set up. Do you want to overwrite it? (y/n): " choice
    case "$choice" in
        y|Y ) echo "Overwriting virtual environment...";;
        * ) exit 1
    esac
fi

rm -rf venv  # Remove existing virtual environment

# Create a new virtual environment
python3 -m venv venv
source venv/bin/activate

echo "Virtual environment is set up."