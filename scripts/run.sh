#!/bin/bash

export PYTHONPATH="$PROJECT_ROOT:$PYTHONPATH"

: "
This is the starting point of your application
Here you can set up environment variables and execute the main script and other subprocesses
It is empty by default until you add your own custom logic
For example, if your application starts at $PROJECT_ROOT/main.py, you can add the following line:
python -m $PROJECT_ROOT/main.py
"