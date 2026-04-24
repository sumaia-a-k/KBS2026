from clips import Environment

from pathlib import Path

def main() -> None:
    clips_file = Path("clips/session2/templates.clp").resolve()
    if not clips_file.exists():
        raise FileNotFoundError(f"CLIPS file not found: {clips_file}")

    env = Environment()
    env.load(str(clips_file))
    env.reset()

    print("\n=== Initial Facts === ")
    for fact in env.facts():
        print(fact)
    print("======================================")
    assert_template = "(assert (employee (name Mark) (manager Alice)))"
    assert_template2 = "(assert (employee (name Flamme) (manager Alice)))"
    env.eval(assert_template)
    env.eval(assert_template2)
    for fact in env.facts():
        print(fact)
    print("============== duplicate a fact exactly (same slots) ============== ")
    env.eval("(set-fact-duplication TRUE)")
    env.eval("(duplicate 2)")
    # also we can duplicate a fact with different slot values, which will always be kept regardless of duplication setting.
    env.eval("(duplicate 2 (name Bob_Copy))")
    for fact in env.facts():
        print(fact)
    print("============== deleting a fact ============== ")
    env.eval("(retract 2)")
    for fact in env.facts():
        print(fact)
    print("========== modifying a fact ================")
    env.eval("(modify 3 (name Bob_Modified))")
    for fact in env.facts():
        print(fact)
if __name__ == "__main__":
	main()
