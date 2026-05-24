#!/usr/bin/env python3
"""Session 7 - Part 4: M1 uses first template, M2 and M3 use both."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/session7/importexport.clp").resolve()
	if not clips_file.exists():
		print(f"Error: CLIPS file not found: {clips_file}")
		return 1

	env = Environment()
	env.add_router(LoggingRouter())

	# The module import/export example is written in a .clp file and loaded
	# the same way older sessions load their CLIPS files.
	env.load(str(clips_file))
	env.eval("(set-strategy breadth)")
	env.reset()
	# env.eval("(set-current-module M1)")
	print("\n=== Session 7 - Part 4: first template in M1, two templates in M2/M3 ===")
	print(f"Loaded file: {clips_file}")
	env.eval("(facts)")
	env.eval("(rules)")
	print("\n=== Focusing M1 M2 M3 and running ===")
	env.eval("(focus M1 M2 M3)")
	env.run()
	print("\n=== Done ===")

	try:
		env.clear()
	except Exception:
		pass

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
