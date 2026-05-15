#!/usr/bin/env python3
"""Session 6 Part 3: interactive runner for diagnosis.clp."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter


def _find_q1_answer(env: Environment) -> int | None:
	"""Return the current q1 menu choice if it has already been asserted.

	The diagnosis knowledge base stores user input as `(answer ...)` facts.
	This helper scans working memory for the latest answer fact for q1 and
	converts its `text` slot to an integer menu choice.

	Returns:
		int | None: The q1 choice when available, otherwise None.
	"""
	for fact in env.facts():
		if fact.template.name != "answer":
			continue
		if str(fact["id"]) != "q1":
			continue
		try:
			return int(fact["text"])
		except (TypeError, ValueError):
			return None
	return None


def main() -> int:
	# Capture CLIPS printout output through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	clips_file = Path("clips/Session6/diagnosis.clp").resolve()

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
	
    # Show the current agenda before the ask rule consumes the menu fact.
	env.eval("(set-strategy breadth)")
	env.eval("(agenda)")

	while True:
		# Keep only fresh user answers for each interaction cycle.
		env.eval("(retract-answer)")
		env.assert_string("(ask q1)")

		# Step CLIPS until ask-question-by-id has actually stored q1.
		choice = None
		while choice is None:
			env.run(limit=1)
			choice = _find_q1_answer(env)

		if choice == 4:
			print("exit ..")
			break

		# Continue running remaining rules for options 1, 2, and 3.
		env.run()

	try:
		env.clear()
	except Exception:
		# Best effort cleanup; some CLIPS constructs may still be in use.
		pass
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
