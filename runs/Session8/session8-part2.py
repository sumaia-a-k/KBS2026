#!/usr/bin/env python3
"""Session 8 Part 2: load battery diagnosis CF example and run CLIPS."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Route CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/session8/example2.clp").resolve()

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
	print("\n=== Running CLIPS rules ===")
	env.eval("(agenda)")
	env.run(limit=1)
	print("\n=== after run1 ===")
	for fact in env.facts():
		print(fact)

	env.eval("(agenda)")
	env.run(limit=1)
	print("\n=== after run2 ===")
	for fact in env.facts():
		print(fact)

	env.eval("(agenda)")
	env.run(limit=1)
	print("\n=== after run3 ===")
	for fact in env.facts():
		print(fact)

	env.eval("(agenda)")
	env.run(limit=1)
	print("\n=== after run4 ===")
	for fact in env.facts():
		print(fact)

	env.eval("(agenda)")
	print("\n=== Final Facts ===")
	for fact in env.facts():
		print(fact)

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
