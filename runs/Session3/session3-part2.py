#!/usr/bin/env python3
"""Session 3 Part 1: test CLIPS deffunction with multiple values.

Loads `clips/session3/function.clp` and calls `triangle-area` for a list of
test inputs to demonstrate both valid and invalid cases.
"""

from pathlib import Path

from clips import Environment, Symbol


# Helper function to check if a deffunction exists in the CLIPS environment
def function_exists(env, name):
    deffunctions = env.call("get-deffunction-list")
    return any(str(func) == name for func in deffunctions)

def to_bool(sym):
    """Convert a CLIPS TRUE/FALSE Symbol to a Python bool."""
	# Symbol("TRUE") creates CLIPS symbol object representing the true value.
    return sym == Symbol("TRUE")

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
		("hello", 3),
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

	result1 = env.eval("(numberp 4)")        # Symbol("TRUE")
	result2 = env.call("integerp" , 3.4)    # Symbol("FALSE")
	result3 = env.call("floatp" , 2)         # Symbol("FALSE")   (2 is integer)
	result4 = env.call("stringp" , "Japan") # Symbol("TRUE")
	result5 = env.call("symbolp" , "Japan") # Symbol("FALSE")   ("Japan" is a string, not a symbol	)
	result6 = env.call("symbolp" , Symbol("Japan")) # Symbol("TRUE")   (Symbol("Japan") is a symbol)
	result7 = env.call("lexemep" , "Japan") # Symbol("TRUE")   (lexeme is a string or symbol)

	print("\nTesting type predicates:")
	print(f"(numberp 4) -> {result1}")	
	print(f"(integerp 3.4) -> {to_bool(result2)}")
	print(f"(floatp 2) -> {to_bool(result3)}")
	print(f"(stringp \"Japan\") -> {to_bool(result4)}")
	print(f"(symbolp \"Japan\") -> {to_bool(result5)}")
	print(f"(symbolp Symbol(\"Japan\")) -> {to_bool(result6)}")
	print(f"(lexemep \"Japan\") -> {to_bool(result7)}")

	return 0


if __name__ == "__main__":
    raise SystemExit(main())
