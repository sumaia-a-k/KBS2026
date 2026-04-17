#!/usr/bin/env python3
"""
session2-part2.py Documentation

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
from pathlib import Path
from clips import Environment


# Create a CLIPS environment
env = Environment()

# Resolve CLIPS file paths relative to this script, not current working directory.
project_root = Path(__file__).resolve().parents[1]
facts_file = project_root / "clips" / "session2" / "company_hierarchy_facts.clp"
rules_file = project_root / "clips" / "session2" / "company_hierarchy_rules.clp"

for clips_file in (facts_file, rules_file):
    if not clips_file.exists():
        print(f"Error: CLIPS file not found: {clips_file}")
        sys.exit(1)

# Load the CLIPS file
try:
    env.load(str(facts_file))
    env.load(str(rules_file))
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
