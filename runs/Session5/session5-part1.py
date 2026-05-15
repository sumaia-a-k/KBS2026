#!/usr/bin/env python3
"""Session 5 Part 1: interactive runner for example1.clp."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def _find_q1_answer(env: Environment) -> int | None:
	"""Extract the latest main-menu selection from working memory.

	Why this helper exists:
	- The CLIPS rules store user input as facts using the `answer` template.
	- The first menu question is identified by id `q1`.
	- Python must read that value to decide whether to continue the loop or exit.

	Behavior:
	- Scan all current facts in the environment.
	- Keep only facts from template `answer`.
	- Keep only the answer whose id is `q1` (the main menu choice).
	- Convert its `text` slot to int and return it.
	- Return None if missing or not a valid integer.

	Returns:
		int: Menu option number (1, 2, 3, or 4).
		None: No q1 answer found yet, or malformed answer value.
	"""
	for fact in env.facts():
		# We only care about user input records, which are asserted as (answer ...).
		if fact.template.name != "answer":
			continue
		# q1 is the main menu question; q2/q3 are follow-up questions for student id.
		if str(fact["id"]) != "q1":
			continue
		try:
			# The answer is stored in slot `text`; convert it to a numeric menu choice.
			return int(fact["text"])
		except (TypeError, ValueError):
			# If q1 exists but cannot be parsed as number, treat as unavailable/invalid.
			return None
	return None


def main() -> int:
	# Capture CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/session5/example1.clp").resolve()

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

	while True:
		# Keep only fresh user answers for each interaction cycle.
		env.eval("(retract-answer)")
		env.assert_string("(ask q1)")

		# Run one activation first so ask-question-by-id captures menu choice.
		env.run(limit=1)

		choice = _find_q1_answer(env)
		if choice == 4:
			print("exit ..")
			break

		# Continue running remaining rules for options 1, 2, and 3.
		env.run()

	# Explicitly clear CLIPS constructs/facts before process exit.
	env.clear()
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
