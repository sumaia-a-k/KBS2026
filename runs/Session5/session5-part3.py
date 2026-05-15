#!/usr/bin/env python3
"""Session 5 Part 3: load example3.clp, reset, and run."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/session5/example3.clp").resolve()

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

	try:
		env.clear()
	except Exception:
		# Best effort cleanup; some CLIPS constructs may still be in use.
		pass

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
