#!/usr/bin/env python3
"""Session 8 Part 3: run the strategy example with a hardcoded strategy."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter

def main() -> int:
	# Route CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	strategy = "complexity"
	# Change this to "complexity" if you want to compare the other strategy.
	clips_file = Path("clips/session8/example3.clp").resolve()

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
	print(f"Strategy: {strategy}")

	env.reset()
	env.eval(f"(set-strategy {strategy})")
	print("\nAgenda before run:")
	env.eval("(agenda)")

	print("\nRunning...")
	env.run()

	print("\nFinal facts:")
	for fact in env.facts():
		print(fact)

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
