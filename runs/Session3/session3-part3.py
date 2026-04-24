#!/usr/bin/env python3
"""Session 3 Part 3: CLIPS operator examples (no .clp file required)."""

from clips import Environment


def show(env: Environment, label: str, expression: str) -> None:
    """Evaluate and print one CLIPS expression with its result."""
    try:
        result = env.eval(expression)
        print(f"{label:12} | {expression:<35} => {result}")
    except Exception as error:
        print(f"{label:12} | {expression:<35} => ERROR: {error}")


def main() -> int:
    env = Environment()

    print("=== CLIPS Comparison/String Operators Examples ===\n")

    print("eq : equal (any type)")
    show(env, "eq", '(eq 10 10)')
    show(env, "eq", '(eq "cat" "cat")')
    show(env, "eq", '(eq red red)')
    show(env, "eq", '(eq "red" red)')
    print()

    print("neq : not equal (any type)")
    show(env, "neq", '(neq 10 20)')
    show(env, "neq", '(neq "cat" "dog")')
    show(env, "neq", '(neq red blue)')
    print()

    print("= : equal (numbers)")
    show(env, "=", '(= 5 5)')
    show(env, "=", '(= 5 5.0)')
    show(env, "=", '(= 5 7)')
    print()

    print("!= : not equal (numbers)")
    show(env, "!=", '(!= 5 7)')
    show(env, "!=", '(!= 5 5)')
    print()

    print("<> : not equal (numbers)")
    show(env, "<>", '(<> 10 9)')
    show(env, "<>", '(<> 10 10)')
    print()

    print(">= : greater than or equal (numbers)")
    show(env, ">=", '(>= 9 9)')
    show(env, ">=", '(>= 10 9)')
    show(env, ">=", '(>= 8 9)')
    print()

    print("<= : less than or equal (numbers)")
    show(env, "<=", '(<= 9 9)')
    show(env, "<=", '(<= 8 9)')
    show(env, "<=", '(<= 10 9)')
    print()

    print("> : greater than (numbers)")
    show(env, ">", '(> 10 9)')
    show(env, ">", '(> 9 9)')
    print()

    print("< : less than (numbers)")
    show(env, "<", '(< 8 9)')
    show(env, "<", '(< 9 9)')
    print()

    print("str-compare : strings")
    show(env, "str-compare", '(str-compare "apple" "apple")')
    show(env, "str-compare", '(str-compare "apple" "banana")')
    show(env, "str-compare", '(str-compare "banana" "apple")')
    print()

    print("Note: str-compare returns 0 if equal, a negative value if first < second,")
    print("and a positive value if first > second (lexicographic order).")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
