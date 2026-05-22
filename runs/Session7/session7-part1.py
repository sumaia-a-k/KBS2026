#!/usr/bin/env python3
"""Session 7"""

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
	"""
	Why build() instead of eval() for defmodule, defrule
	In the clips Python module, there are two ways to send CLIPS code:
	 1- env.eval("...") : it evaluates and executes an expression immediately. 
	 2- env.build("...") : loads a CLIPS construct (It parses, compiles, and installs). 
	 What is a construct?
        Constructs are permanent definitions in CLIPS. Examples:
        (defmodule ...)
        (defrule ...)
        (deftemplate ...)
        (deffacts ...)
	     These do not immediately “do” something
	      they add rules, modules, or templates to the environment. 
	      They must be parsed and stored for later use.
	
	What is a command / expression?
        Commands and expressions perform an action or compute a value right away. Examples:
        (assert (A))
        (get-current-module)
        (facts)
        (reset)
		(set-strategy breadth)
		(set-current-module M1)
	"""
	modMain = env.eval("(get-current-module)")
	print(f"Current module: {modMain}")
	env.build("(defmodule M1)")
	modeM1 = env.eval("(get-current-module)")
	print(f"Current module: {modeM1}")
	env.build("(defrule r1 (A) => (printout t \"Module A M1\" crlf))")
	env.build("(defmodule M2)")
	modeM2 = env.eval("(get-current-module)")
	print(f"Current module: {modeM2}")
	env.build("(defrule r2 (B) => (printout t \"Module B M2\" crlf))")
	env.build("(defrule r3 (A) => (printout t \"Module A M2\" crlf))")

	env.reset() # or env.eval("(reset)")

	env.eval("(set-current-module M1)")
	env.eval("(assert (A))")
	env.eval("(set-current-module M2)")
	env.eval("(assert (B))")
	env.eval("(assert (A))")
	env.eval("(facts)")
	env.eval("(agenda)")
	env.eval("(rules)")
	#----------------------
	print("\n=== Setting current module to M1 and running ===")
	env.eval("(set-current-module M1)")
	env.run()
	print()
    #---------------
	print("\n=== Focusing module M1 and running ===")
	env.eval("(focus M1)")
	modeM1 = env.eval("(get-current-module)")
	print(f"Current : {modeM1}")
	# run uses the focus stack; set-current-module alone does not control execution.
	env.run()
	print()
	try:
		env.clear()
	except Exception:
		# Best effort cleanup; some CLIPS constructs may still be in use.
		pass
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
