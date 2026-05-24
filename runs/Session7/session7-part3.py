#!/usr/bin/env python3
"""Session 7 - Part 3: Define constructs for other modules while in MAIN."""

import logging

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	env = Environment()
	env.add_router(LoggingRouter())

	print("\n=== Build modules ===")
	env.build("(defmodule M1)")
	env.build("(defmodule M2)")

	env.eval("(set-current-module MAIN)")
	current_module = env.eval("(get-current-module)")
	print(f"Current module before definitions: {current_module}")

	print("\n=== Define M1 constructs while staying in MAIN ===")
	env.build("(deffacts M1::m1Facts (m1 A) (m1 B) (m1 C))")
	env.build(
		"(deffunction M1::show-tag (?x) (printout t \"M1 function called with: \" ?x crlf))"
	)
	env.build(
		"(defrule M1::m1Rule (m1 ?x) => (show-tag ?x) (printout t \"M1 rule fired with: \" ?x crlf))"
	)
	current_module = env.eval("(get-current-module)")
	print(f"Current module after M1 definitions: {current_module}")
	
	print("\n=== Define M2 constructs using M2:: prefix ===")
	print(f"Current module before M2 definitions: {env.eval('(get-current-module)')}")
	env.build("(deffacts M2::m2Facts (m2 10) (m2 20))")
	env.build(
		"(deffunction M2::double (?n) (return (* ?n 2)))"
	)
	env.build(
		"(defrule M2::m2Rule (m2 ?n) => (printout t \"M2 rule fired, double=\" (double ?n) crlf))"
	)

	current_module = env.eval("(get-current-module)")
	print(f"Current module after M2 definitions: {current_module}")

	print("\n=== Reset and inspect ===")
	env.reset()
	env.eval("(facts)")
	env.eval("(rules)")
	env.eval("(agenda)")

	print("\n=== Run by focusing M1 then M2 ===")
	print("Expected firing order: M1 then M2")
	env.eval("(focus M1 M2)")
	env.run()

	print("\n=== Done ===")

	try:
		env.clear()
	except Exception:
		pass

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
