from pathlib import Path

from clips import Environment


def main() -> int:
    clips_file = Path("clips/session3/example2.clp").resolve()

    if not clips_file.exists():
        print(f"Error: CLIPS file not found: {clips_file}")
        return 1

    env = Environment()
    env.load(str(clips_file))
    env.reset()
    env.run()

    print("\n=== Initial Facts === ")
    for fact in env.facts():
        print(fact)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())

