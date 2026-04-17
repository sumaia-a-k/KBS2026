"""Session 2 Part 4: deffacts duplication demo with clipspy.

This script loads deffacts from clips/session2/duplicatedFacts.clp and compares:
1) Default behavior (fact duplication disabled)
2) Behavior after enabling duplication with (set-fact-duplication TRUE)
"""

from pathlib import Path

from clips import Environment


def print_anime_facts(env: Environment, title: str) -> None:
	"""Print only anime facts and their count."""
	anime_facts = [fact for fact in env.facts() if str(fact).startswith("(anime ")]

	print(f"\n=== {title} ===")
	print(f"Total anime facts: {len(anime_facts)}")
	for fact in anime_facts:
		print(f"f-{fact.index}: {fact}")


def run_case(clips_file: Path, duplication_enabled: bool) -> None:
	"""Load deffacts and show the resulting asserted facts after reset."""
	env = Environment()
	env.load(str(clips_file))
	if duplication_enabled:
		env.eval("(set-fact-duplication TRUE)")
		label = "Case 2: duplication enabled"
		details = "After reset with (set-fact-duplication TRUE)"
	else:
		label = "Case 1: default behavior (duplication disabled)"
		details = "After reset with default duplication setting"
	print(label)
	env.reset()
	print_anime_facts(env, details)


def main() -> None:
	clips_file = Path("clips/session2/duplicatedFacts.clp").resolve()

	if not clips_file.exists():
		raise FileNotFoundError(f"CLIPS file not found: {clips_file}")

	run_case(clips_file, duplication_enabled=False)


if __name__ == "__main__":
	main()
