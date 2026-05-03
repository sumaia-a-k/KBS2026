#!/usr/bin/env python3
"""Session 3 Part 4: load CLIPS file, reset, show activations, and run."""

import logging
from pathlib import Path

from clips import Environment

def main() -> int:

    clips_file = Path("clips/session4/logicalCondition.clp").resolve()

    if not clips_file.exists():
        print(f"Error: CLIPS file not found: {clips_file}")
        return 1

    env = Environment()
    

    try:
        env.load(str(clips_file))
    except Exception as error:
        print(f"Error loading CLIPS file: {error}")
        return 1

    print(f"Loaded CLIPS file: {clips_file}")

    env.reset()
    env.run()
    facts = env.facts()
    env.eval("(retract 1)")  # Retract the first fact
    print("\n=== Facts after retracting the first fact ===")    
    for fact in facts:
        print(fact)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())