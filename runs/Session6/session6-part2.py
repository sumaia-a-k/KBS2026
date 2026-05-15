#!/usr/bin/env python3
"""Session 6 Part 2: run sailence.clp with step-by-step agenda inspection."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/Session6/sailence.clp").resolve()

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

	# Execute the exact step sequence requested:
	# (reset)
	# (run 1)
	# (facts)
	# (run 1)
	# (facts)
	# (agenda)
	# (run 1)
	# (facts)
	# (agenda)
	# (run 1)
	# (facts)
	# (agenda)
	env.reset()
	env.eval("(agenda)")
	print("\n=== Step 1: run 1 cycle ===")
	
	env.run(limit=1)
	env.eval("(facts)")
	env.eval("(agenda)")
	print("\n=== Step 2: run 1 cycle ===")

	env.run(limit=1)
	env.eval("(facts)")
	env.eval("(agenda)")
	print("\n=== Step 3: run 1 cycle ===")

	env.run(limit=1)
	env.eval("(facts)")
	env.eval("(agenda)")
	print("\n=== Step 4: run 1 cycle ===")

	env.run(limit=1)
	env.eval("(facts)")
	env.eval("(agenda)")

	try:
		env.clear()
	except Exception:
		# Best effort cleanup; some CLIPS constructs may still be in use.
		pass
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
