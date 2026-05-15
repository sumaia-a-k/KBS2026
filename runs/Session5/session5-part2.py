#!/usr/bin/env python3
"""Session 5 Part 2: run example2.clp and demonstrate core constructs."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/session5/example2.clp").resolve()

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

	print("\n=== Function Calls: explicit vs implicit return ===")
	explicit_result = env.call("classify-score", 26)
	implicit_result = env.call("classify-score-implicit", 26)
	print(f"classify-score(26)          -> {explicit_result}")
	print(f"classify-score-implicit(26) -> {implicit_result}")

	print("\n=== Function Call: do-while (countdown) ===")
	env.call("countdown", 5)
	
	print("\n=== Rule Run: for-all-facts (show-top-students) ===")
	env.run(limit=1)

	try:
		env.clear()
	except Exception:
		# Best effort cleanup; some CLIPS constructs may still be in use.
		pass
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
