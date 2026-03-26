#!/usr/bin/env python3
"""
run.py Documentation

Overview
--------
run.py is a Python script that serves as a runner for CLIPS (C Language Integrated Production System) programs.
It uses the `clips` Python library to load, reset, and execute a CLIPS knowledge base file, then displays the final facts after execution.
The script is designed to be configurable via environment variables and includes basic error handling and debugging output.

Dependencies
------------
- Python 3.x: The script requires Python 3 to run.
- clips: Python bindings for CLIPS. Install via `pip install clips`.
- python-dotenv: For loading environment variables from a `.env` file. Install via `pip install python-dotenv`.
- pathlib: Standard library module (available in Python 3.4+).

Configuration
-------------
The script reads configuration from environment variables, which can be set in a `.env` file in the same directory:

- CLIPS_FILE: Path to the CLIPS file to load (default: 'clips/family_test.clp'). The path is relative to the script's working directory.
- DEBUG: Boolean flag to enable debug output (default: 'False'). Set to 'true' (case-insensitive) to print success messages during file loading.

Example .env file:
    CLIPS_FILE=clips/familyMembers.clp
    DEBUG=true

Usage
-----
1. Ensure all dependencies are installed.
2. Create or modify a .env file for configuration if needed.
3. Run the script: python run.py (or python3 run.py on some systems).

The script will:
- Load the specified CLIPS file.
- Reset the CLIPS environment.
- Run the CLIPS program.
- Print all final facts in the knowledge base.

Code Structure
--------------
- Imports: Loads necessary modules for file handling, environment variables, and CLIPS integration.
- Environment Loading: Uses dotenv to load variables from .env.
- File Validation: Checks if the CLIPS file exists before proceeding.
- CLIPS Environment Setup: Creates an Environment instance and loads the CLIPS file.
- Execution: Resets the environment, runs the program, and displays results.
- Error Handling: Exits with an error message if the file is not found or loading fails.

Error Handling
--------------
- If the CLIPS file does not exist, prints an error and exits.
- If loading the CLIPS file fails, prints the exception and exits.
- No other exceptions are caught; standard Python errors may occur.

Output
------
- If DEBUG=true, prints a success message after loading the file.
- Prints "=== Running CLIPS Program ===" before execution.
- After execution, prints "=== Final Facts ===" followed by each fact in the knowledge base.

Notes
-----
- The script assumes the CLIPS file contains a valid, runnable program.
- Facts are printed in CLIPS's default string representation.
- For more advanced CLIPS integration, consider extending the script with additional environment interactions (e.g., asserting facts, querying rules).
"""

import sys
import os
from pathlib import Path
from dotenv import load_dotenv
from clips import Environment

# Load environment variables from .env file
load_dotenv()

# Get configuration from .env
clips_file = os.getenv('CLIPS_FILE', 'clips/family_test.clp')
debug = os.getenv('DEBUG', 'False').lower() == 'true'

# Ensure the file exists
if not Path(clips_file).exists():
    print(f"Error: CLIPS file not found at '{clips_file}'")
    sys.exit(1)

# Create a CLIPS environment
env = Environment()

# Load the CLIPS file
try:
    env.load(clips_file)
    if debug:
        print(f"✓ File loaded successfully: {clips_file}\n")
except Exception as e:
    print(f"Error loading file: {e}")
    sys.exit(1)

# Reset and run the program
env.reset()
print("=== Running CLIPS Program ===\n")
env.run()

# Display results
print("\n=== Final Facts ===")
for fact in env.facts():
    print(fact)
