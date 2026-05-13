# GitHub Copilot RTK Usage Instructions

To maximize efficiency and reduce token usage during our session, **you must execute all terminal commands through the `rtk` (Rust Token Killer) proxy**. 

`rtk` intercepts, filters, and compresses the standard output of tools so that your LLM context window is not saturated by long stack traces, verbose builds, or bloated text.

## Rule
**ALWAYS prefix terminal commands with `rtk`.** 

### Examples:
- **Git:** Use `rtk git status`, `rtk git log -10`
- **Node/NPM:** Use `rtk npm install`, `rtk npm test`
- **Rust/Cargo:** Use `rtk cargo build`, `rtk cargo clippy`
- **Python:** Use `rtk pytest`, `rtk pip install -r requirements.txt`
- **Search:** Use `rtk grep -rn "pattern" .`

### Exception:
If a command requires strict interactive TTY (like `vim`, `nano`), do not wrap it. But for all query/build/test commands executed in the background by you, `rtk` must be used.

### Usage Validation:
If an `rtk` command returns an error about `rtk: command not found`, assume `rtk` is not installed on the system, gracefully degrade to running the standard command, and remind the user to install `rtk` via `https://github.com/rtk-ai/rtk`.
