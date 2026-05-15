#!/usr/bin/env python3
"""Session 6: run multiSlots.clp and demonstrate multislot behavior."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/Session6/multiSlots.clp").resolve()

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
	env.eval("(set-strategy breadth)")
	env.eval("(agenda)")
	print("\n=== Running CLIPS rules ===")
	env.run()

	try:
		env.clear()
	except Exception:
		# Best effort cleanup; some CLIPS constructs may still be in use.
		pass
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
