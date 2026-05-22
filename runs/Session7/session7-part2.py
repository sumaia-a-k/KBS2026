#!/usr/bin/env python3
"""Session 7 - Part 2: Demonstrate CLIPS focus with 3 modules."""

import logging

from clips import Environment
from clips.routers import LoggingRouter


def main() -> int:
	# Capture CLIPS printout through Python logging.
	logging.basicConfig(level=logging.INFO, format="%(message)s")

	env = Environment()
	env.add_router(LoggingRouter())
	current_module = env.eval("(get-current-module)")
	print(f"Current module at the beginning: {current_module}")
	print()
	print("\n=== Building modules and rules ===")
	env.build("(defmodule M1)")
	env.build("(defmodule M2)")
	env.build("(defmodule M3)")
	current_module = env.eval("(get-current-module)")
	print(f"Current module after building modules: {current_module}")
	print()
	
	env.eval("(set-current-module M1)")
	env.build(
		"(defrule m1-rule (token M1) => (printout t \"[M1] rule fired\" crlf))"
	)

	env.eval("(set-current-module M2)")
	env.build(
		"(defrule m2-rule (token M2) => (printout t \"[M2] rule fired\" crlf))"
	)

	env.eval("(set-current-module M3)")
	env.build(
		"(defrule m3-rule (token M3) => (printout t \"[M3] rule fired\" crlf))"
	)
	current_module = env.eval("(get-current-module)")
	print(f"Current module after building rules: {current_module}")
	print()
	# Reset before asserting runtime facts.
	env.reset()
	current_module = env.eval("(get-current-module)")
	print(f"Current module after reset : {current_module}")
	env.build(
		"(defrule main-rule (token main) => (printout t \"[main] rule fired\" crlf))"
	)
	print("\n=== Asserting facts in each module ===")
	env.eval("(assert (token main))")
	env.eval("(set-current-module M1)")
	env.eval("(assert (token M1))")
	env.eval("(set-current-module M2)")
	env.eval("(assert (token M2))")
	env.eval("(set-current-module M3)")
	env.eval("(assert (token M3))")
    # comment this out and check the result
	# print("\n=== Running without focus (default focus MAIN) ===")
	# env.run()
	print("\n=== Using focus M2 M1 M3 and running ===")
	print("Expected firing order: M3, then M2, then M1")
	# focus pushes modules onto the focus stack; last one is executed first.
	env.eval("(focus M2 M1 M3)")
	env.run()
	env.eval("(focus MAIN)")
	env.run()
	print("\n=== Done ===")

	try:
		env.clear()
	except Exception:
		pass

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
