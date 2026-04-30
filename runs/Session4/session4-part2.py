#!/usr/bin/env python3
"""Session 3 Part 4: load CLIPS file, reset, show activations, and run."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
    # force=True ensures this works even when another tool configured logging.
    # explicitly tell clipspy to capture all CLIPS (printout t ...) messages and send them through Python’s logging mechanism.
    logging.basicConfig(level=logging.INFO, format="%(message)s")

    clips_file = Path("clips/session4/example1.clp").resolve()

    if not clips_file.exists():
        print(f"Error: CLIPS file not found: {clips_file}")
        return 1

    env = Environment()
    env.add_router(LoggingRouter())

    try:
        env.load(str(clips_file))
    except Exception as error:
        print(f"Error loading CLIPS file: {error}")
        return 1

    print(f"Loaded CLIPS file: {clips_file}")

    env.reset()
    env.run()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())