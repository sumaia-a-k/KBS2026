#!/usr/bin/env python3
"""Session 2 Part 1 runner with CLIPS-style tracing.

---------------------
1) Loads the CLIPS knowledge base path from `.env` using `CLIPS_FILE`.
2) Loads that CLIPS file into a clipspy `Environment`.
3) Prints agenda before `reset` (typically empty, because `deffacts` are not
    asserted yet).
4) Calls `reset`, then prints the initial facts and agenda again.
5) Runs one activation at a time (`env.run(limit=1)`) so you can observe
    rule firings step by step.
6) Prints final facts after the agenda is exhausted.

Typical `.env` example
----------------------
CLIPS_FILE=clips/session2/family.clp

Why step-by-step run is useful
------------------------------
In CLIPS IDE, you can watch agenda/facts while running. This script reproduces
that idea in terminal output, showing which rule is next and which fact numbers
activated each rule.
"""

import os
import re
import sys
from pathlib import Path

from dotenv import load_dotenv
from clips import Environment


def activation_fact_details(env: Environment, activation) -> str:
    """Return supporting fact numbers for one activation.

    CLIPS activation pretty-print strings include matched fact ids in the form
    `f-<number>`. Example: `0 grandparent: f-10,f-16`.

    Args:
        env: The clipspy environment, i.e., one independent CLIPS engine
            instance. It holds facts, rules, agenda, and functions in memory.
            Think of it like one CLIPS IDE session.
        activation: One activation object from `env.activations()`.

    Returns:
        A comma-separated string of fact numbers, e.g. "10, 16".
        If parsing fails, a short fallback message is returned.
    """
    # Regex explanation:
    # r"f-(\d+)"
    # - f-      : literal text "f-" used by CLIPS fact ids (e.g., f-10)
    # - (\d+)   : one or more digits, captured as a group (e.g., "10")
    # re.findall returns every captured number found in the activation string.
    fact_indexes = [int(value) for value in re.findall(r"f-(\d+)", str(activation))]

    if not fact_indexes:
        return "(could not resolve supporting facts)"

    return ", ".join(str(fact_index) for fact_index in fact_indexes)


def print_facts(env: Environment, title: str) -> None:
    """Print current working-memory facts with their CLIPS fact ids.

    This mirrors the CLIPS `(facts)` output style but keeps it simple and
    readable for Python learners.

    Args:
        env: The clipspy environment.
        title: Section title printed above the fact list.
    """
    facts = list(env.facts())
    print(f"\n=== {title} ===")
    if not facts:
        print("(empty)")
        return

    for fact in facts:
        print(f"f-{fact.index}: {fact}")


def print_agenda(env: Environment, title: str) -> list:
    """Print current activations (agenda entries) and return them.

    For each activation, this prints:
    - Rule name
    - Fact numbers that matched the rule's LHS patterns

    The numbering in `enumerate(..., start=1)` is for display only so the
    agenda is easier to read for humans. It does not affect CLIPS execution
    order; CLIPS agenda strategy still decides which activation fires first.

    Args:
        env: The clipspy environment.
        title: Section title printed above the agenda list.

    Returns:
        A list of activations currently on the agenda.
    """
    activations = list(env.activations())
    print(f"\n=== {title} ===")
    if not activations:
        print("(empty)")
        return activations

    for index, activation in enumerate(activations, start=1):
        print(f"{index}. rule={activation.name}")
        print(f"   activated_by_fact_numbers: {activation_fact_details(env, activation)}")
    return activations


def main() -> int:
    """Program entry point.

    Returns:
        0 on success, 1 on configuration/load errors.
    """
    # Resolve project root from this file location so execution is stable
    # no matter which directory the terminal is currently in.
    #
    # Path(__file__).resolve().parents is zero-based:
    # parents[0] -> folder containing this script (runs)
    # parents[1] -> one level above runs (project root)
    # In this project, we use parents[1] to reach the root that contains .env.
    project_root = Path(__file__).resolve().parents[1]
    load_dotenv(project_root / ".env")

    # Read CLIPS file path from .env.
    clips_file_value = os.getenv("CLIPS_FILE")
    if not clips_file_value:
        print("Error: CLIPS_FILE is not set in .env")
        return 1

    # If CLIPS_FILE is relative, interpret it relative to project root.
    clips_path = Path(clips_file_value)
    if not clips_path.is_absolute():
        clips_path = project_root / clips_path
    clips_path = clips_path.resolve()

    if not clips_path.exists():
        print(f"Error: CLIPS file not found: {clips_path}")
        return 1

    env = Environment()

    try:
        env.load(str(clips_path))
    except Exception as error:
        print(f"Error loading CLIPS file: {error}")
        return 1

    print(f"Loaded CLIPS file: {clips_path}")

    # Before reset: rules may exist, but deffacts are not asserted yet.
    print_agenda(env, "Agenda Before reset")

    # After reset: initial facts are asserted, activations are generated.
    env.reset()
    print_facts(env, "Initial Facts After reset")
    print_agenda(env, "Agenda After reset")

    print("\n=== Step-by-step run ===")
    step = 1
    total_fired = 0

    while True:
        activations = print_agenda(env, f"Agenda Before step {step}")
        if not activations:
            break

        # Show which activation will fire next, then run only one step.
        print(f"Step {step}: firing next rule -> {activations[0].name}")
        fired_now = env.run(limit=1)
        total_fired += fired_now
        
        print("\n=== Current Facts ===")
        for fact in env.facts():
            print(fact)

        if fired_now == 0:
            break

        step += 1

        print("===========================================")

    print(f"\nRun completed. Total fired activations: {total_fired}")

    print("\n=== Final Facts ===")
    for fact in env.facts():
        print(fact)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
