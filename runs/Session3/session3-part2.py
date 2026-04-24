#!/usr/bin/env python3
"""Session 3 Part 1: test CLIPS deffunction with multiple values.

Loads `clips/session3/function.clp` and calls `triangle-area` for a list of
test inputs to demonstrate both valid and invalid cases.
"""

from pathlib import Path

from clips import Environment


# Helper function to check if a deffunction exists in the CLIPS environment
def function_exists(env, name):
    deffunctions = env.call("get-deffunction-list")
    return any(str(func) == name for func in deffunctions)


def main() -> int:
	clips_file = Path("clips/session3/localVariableInsideFunction.clp").resolve()

	if not clips_file.exists():
		print(f"Error: CLIPS file not found: {clips_file}")
		return 1

	env = Environment()

	try:
		env.load(str(clips_file))
	except Exception as error:
		print(f"Error loading CLIPS file: {error}")
		return 1

	# env.reset()

	test_cases = [
		(10, 5),
		(8, 3),
		(1.5, 2.0),
		(0, 5),
		(-4, 7),
		(6, -2),
	]

	print(f"Loaded CLIPS file: {clips_file}")
	print("\nTesting triangle-area(base, height):")

	if not function_exists(env, "triangle-area"):
		print("Error: 'triangle-area' function not found in CLIPS environment.")
	else:
		for base, height in test_cases:
			result = env.call("triangle-area", base, height)
			print(f"base={base}, height={height} -> result={result}")

	return 0


if __name__ == "__main__":
    raise SystemExit(main())
