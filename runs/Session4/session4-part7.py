#!/usr/bin/env python3
"""Session 4 Part 7: inspect activations, retract/reassert, and modify facts."""

import logging
from pathlib import Path

from clips import Environment
from clips.routers import LoggingRouter




def print_agenda(env, label):
    print(f"\n{label}")
    acts = list(env.activations())
    if not acts:
        print("(agenda empty)")
    else:
        for i, act in enumerate(acts, 1):
            print(f"{i}. {act}")


def main() -> int:
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    clips_file = Path("clips/session4/activation.clp").resolve()
    if not clips_file.exists():
        print(f"Error: CLIPS file not found: {clips_file}")
        return 1
    env = Environment()
    env.add_router(LoggingRouter())
    env.eval("(set-strategy breadth)")
    try:
        env.load(str(clips_file))
    except Exception as error:
        print(f"Error loading CLIPS file: {error}")
        return 1
    env.reset()
    print("Initial facts:")
    for fact in env.facts():
        print(f"f-{fact.index}: {fact}")
    print_agenda(env, "Initial agenda:")

    # 1. Fire the first rule (should match fact 1)
    print("\n1-Fire first activation (should match fact 1):")
    env.run(limit=1)
    print_agenda(env, "Agenda after firing first rule:")
    print("------------------------------------")
    # 2. Retract fact 1 (by index)
    print("2-Retract fact 1:")
    env.eval("(retract 1)")
    print_agenda(env, "Agenda after retracting fact 1:")
    print("------------------------------------")
    # 3. Reassert fact 1 (same values)
    print("3-Reassert fact 1:")
    env.assert_string("(my_template (slot1 value1) (slot2 value2))")
    print_agenda(env, "Agenda after reasserting fact 1:")
    print("------------------------------------")
    # 4. Fire the next rule (should match fact 2)
    print("\n4-Fire next activation (should match fact 2):")
    env.run(limit=1)
    print_agenda(env, "Agenda after firing second rule:")
    print("------------------------------------")
    # 5. Modify fact 2 (by index)
    print("5-Modify fact 2:")
    for fact in env.facts():
        if fact.index == 2:
            fact.modify_slots(slot2="value4_modified")
            break
    print_agenda(env, "Agenda after modifying fact 2:")
    print("------------------------------------")
    # 6. Fire the next rule (should match fact 3)
    print("\n6-Fire next activation (should match fact 3):")
    env.run(limit=1)
    print_agenda(env, "Agenda after firing third rule:")
    print("------------------------------------")
    # 7. Allow duplication
    print("7-Allow duplication of facts...")
    env.eval("(set-fact-duplication TRUE)")
    print("------------------------------------")
    # 8. Duplicate fact 3 (by index)
    print("Duplicate fact 3:")
    env.eval("(duplicate 3)")
    print_agenda(env, "Agenda after duplicating fact 3:")
    print("------------------------------------")
    # 9. Fire the new activation
    print("\n9-Fire activation from duplicated fact:")
    env.run(limit=1)
    print_agenda(env, "Final agenda:")

    print("\nFinal facts:")
    for fact in env.facts():
        print(f"f-{fact.index}: {fact}")
    return 0



if __name__ == "__main__":
    raise SystemExit(main())