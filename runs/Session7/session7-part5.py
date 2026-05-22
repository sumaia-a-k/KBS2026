#!/usr/bin/env python3
"""Session 7 - Part 5: River crossing puzzle using CLIPS modules."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/session7/practicalexample.clp").resolve()
	if not clips_file.exists():
		print(f"Error: CLIPS file not found: {clips_file}")
		return 1

	env = Environment()
	env.add_router(LoggingRouter())

	# Load the CLIPS module-based puzzle file the same way as older sessions.
	env.load(str(clips_file))
	env.eval("(set-strategy breadth)")
	env.reset()

	print("\n=== Session 7 - Part 5: Shepherd, sheep, fox, and grass ===")
	print(f"Loaded file: {clips_file}")
	print("\n=== Focusing MOVEMENTS CONSTRAINTS and running ===")
	env.eval("(focus MOVEMENTS CONSTRAINTS)")
	env.run()
	print("\n=== Done ===")

	try:
		env.clear()
	except Exception:
		pass

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
