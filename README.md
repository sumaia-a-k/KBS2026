> **📝 Tip:** For better readability, open this README in VS Code's **Preview mode** by right-clicking the file tab and selecting "Open Preview" (or press `Ctrl+Shift+V`).

# CLIPS Project Runner

A Python-based CLIPS (Clips Language Integrated Production System) executor that reads CLIPS programs from files and runs them with inference engine support.

## Project Structure

```
clipsPY/
├── .env                    # Configuration file (specifies which CLIPS file to run)
├── run.py                  # Main Python script (reads .env and executes CLIPS)
├── run.bat                 # Windows batch script (shortcut to run python run.py)
├── README.md               # This file
└── clips/                  # Folder containing CLIPS program files
    ├── family_test.clp     # Example CLIPS program (family facts & rules)
    └── *.clp               # Add more CLIPS files here
```

## Prerequisites

- Python 3.7+
- `clipspy` package (CLIPS Python bindings)
- `python-dotenv` package (for .env file support)

## Recommended Tools

### VS Code CLIPS Language Support Extension

If you're using **Visual Studio Code**, it's recommended to install the CLIPS language support extension for better syntax highlighting and editing experience:

- Search for "CLIPS" in the VS Code Extensions marketplace
- Install a CLIPS language support extension to get syntax highlighting for `.clp` files

This will make working with CLIPS program files much easier.

### Installation

#### Step 1: Create a Virtual Environment

A virtual environment (`kbs2026_env`) keeps your project dependencies isolated from your system Python. This prevents conflicts between projects.

```powershell
python -m venv kbs2026_env
```

#### Step 2: Activate the Virtual Environment

**Windows (PowerShell command):**
```powershell
kbs2026_env\Scripts\activate
```

**Mac/Linux (bash or Git Bash terminal):**
```bash
source kbs2026_env/bin/activate
```

You'll see `(kbs2026_env)` appear in your terminal prompt when activated.

✅ **Verification:** After activation, your terminal should display:
```
(kbs2026_env) PS D:\KBS2026\KBS2026>  # Windows
(kbs2026_env) user@machine:~/KBS2026$  # Mac/Linux
```

If you see `(kbs2026_env)` at the start of your prompt, the environment is successfully activated!

#### Step 3: Install Dependencies

```powershell
pip install -r requirements.txt
```

Or manually install:
```powershell
pip install clipspy python-dotenv
```

#### Deactivate Virtual Environment

When you're done working on the project:
```powershell
deactivate
```

#### What is `kbs2026_env`?

- **`kbs2026_env`** is a directory containing an isolated Python environment for this project
- It includes a Python interpreter copy, pip, and a `site-packages` folder for libraries
- Keeps project dependencies separate from system Python and other projects
- Always activate it before running the project

## Configuration

### Setting Up the `.env` File

Before running the project, you need to create a `.env` file from the example template:

```powershell
copy .env.example .env
```

**Mac/Linux:**
```bash
cp .env.example .env
```

Then edit the `.env` file with your desired configuration values.

### `.env` File

The `.env` file contains configuration settings:

```
CLIPS_FILE=clips/family_test.clp
DEBUG=False
```

**Variables:**
- `CLIPS_FILE` - Path to the CLIPS program file to execute (relative to project root)
- `DEBUG` - Set to `True` for verbose output, `False` for normal operation

### How To Use

#### Option 1: Run using Python (Recommended)

```powershell
python run.py
```

#### Option 2: Run using Batch Script (Windows)

```powershell
run.bat
```

Both methods do the same thing - they execute the CLIPS file specified in `.env`.

## What `run.py` Does

1. **Loads configuration** from `.env` file
2. **Creates a CLIPS environment** using the clipspy library
3. **Loads the CLIPS program** from the file specified in `CLIPS_FILE`
4. **Resets the environment** and initializes all facts
5. **Runs the inference engine** to fire rules and derive new facts
6. **Displays the results:**
   - Console output from `printout` statements in CLIPS
   - All final facts (original + derived)

## Example: Running family_test.clp

The included `family_test.clp` contains:

**Facts:**
- Alice is the parent of Bob
- Alice is the parent of Charlie

**Rule:**
- If two people share the same parent, they are siblings

**Running it:**

```powershell
python run.py
```

**Output:**
```
File loaded successfully!

=== Running CLIPS Program ===

Charlie and Bob are siblings
Bob and Charlie are siblings

=== Final Facts ===
(parent Alice Bob)
(parent Alice Charlie)
(sibling Charlie Bob)
(sibling Bob Charlie)
```

## Adding New CLIPS Programs

1. **Create a new `.clp` file** in the `clips/` folder:
   ```
   clips/my_program.clp
   ```

2. **Update `.env`** to point to it:
   ```
   CLIPS_FILE=clips/my_program.clp
   ```

3. **Run the program:**
   ```powershell
   python run.py
   ```

## CLIPS File Template

```clips
; Define facts
(deffacts startup
  (fact1 value1)
  (fact2 value2)
)

; Define rules
(defrule my_rule
  (fact1 ?x)
  =>
  (printout t "Fact1 is: " ?x crlf)
)
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `No module named 'clips'` | Install clipspy: `pip install clipspy` |
| `No module named 'dotenv'` | Install python-dotenv: `pip install python-dotenv` |
| File not found error | Check that `CLIPS_FILE` path in `.env` is correct |
| No output from rules | Ensure facts exist before rules reference them; use `(deffacts)` block |

## References

- [CLIPS Language Documentation](http://clipsrules.sourceforge.net/)
- [clipspy GitHub Repository](https://github.com/noxdafox/clipspy)
