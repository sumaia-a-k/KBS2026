"""Session 2 Part 3: demonstrate fact duplication in clipspy.

Goal:
1) Assert the same fact twice with default settings.
2) Show that only one fact exists.
3) Enable duplication with (set-fact-duplication TRUE).
4) Assert the same fact twice again and show both are kept.
"""

from clips import Environment


def print_facts(env: Environment, title: str) -> None:
	facts = list(env.facts())
	print(f"\n=== {title} ===")
	print(f"Total facts: {len(facts)}")
	for fact in facts:
		print(f"f-{fact.index}: {fact}")


def main() -> None:
	env = Environment()
	# env.eval("(set-fact-duplication TRUE)")
	env.assert_string("(name Tom)")
	env.assert_string("(name Tom)")
	print_facts(env, "facts")


if __name__ == "__main__":
	main()

