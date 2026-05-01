#!/usr/bin/env python3
"""Session 4 Part 2-2: show Rete early filtering with &: versus test."""

from pathlib import Path

from clips import Environment


def build_env(clips_file: Path) -> Environment:
    env = Environment()
    env.load(str(clips_file))
    env.reset()
    return env


def collect_stats(env: Environment) -> tuple[tuple[int, int], tuple[int, int]]:
    """Return CLIPS match statistics for the two comparison rules.

    What it does:
    - Finds rule find-team-alpha (uses &: in slot constraints).
    - Finds rule find-team-test (uses test conditional elements).
    - Calls matches() on each rule to ask CLIPS for match counters.

    What matches() is:
    - A CLIPS/clipspy rule inspection API that reports matching activity.
    - It does not fire rules; it only reports match statistics.

    Return value:
    - A pair: (alpha_stats, test_stats)
    - Each stats tuple is:
      (pattern_matches, partial_matches)
    """
    alpha = env.find_rule("find-team-alpha").matches()[:2]
    test = env.find_rule("find-team-test").matches()[:2]
    return alpha, test


def print_stats(alpha: tuple[int, int], test: tuple[int, int]) -> None:
    print("\n=== Rete Comparison (&: vs test) ===")
    print("Tuple format: (pattern-matches, partial-matches)")
    print(f"find-team-alpha (&: in pattern) : {alpha}")
    print(f"find-team-test  (test CE later) : {test}")
    print(f"Pattern-match delta (test - &:): {test[0] - alpha[0]}")


def main() -> int:
    clips_file = Path("clips/session4/example2.clp").resolve()

    if not clips_file.exists():
        print(f"Error: CLIPS file not found: {clips_file}")
        return 1

    try:
        env = build_env(clips_file)
        alpha, test = collect_stats(env)
        print_stats(alpha, test)
    except Exception as error:
        print(f"Error while running comparison: {error}")
        return 1

    print("\nObservation:")
    print("- &: constraints are compiled into pattern nodes, so low-skill facts are pruned early.")
    print("- test conditions run after pattern matching/joining, so they do not reduce earlier pattern traffic.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())