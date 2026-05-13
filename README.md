# RTK for GitHub Copilot & VS Code

This is a ready-to-use template that optimizes **GitHub Copilot in VS Code** using [RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk). 

`rtk` is a proxy that filters terminal commands directly, compressing the noisy output before it reaches the Copilot LLM. This saves **60-90%** in tokens, preventing context window bloat and improving Copilot's reasoning.

## 🚀 Easy Installation Guide

### 1. Install RTK Globally
Open your VS Code terminal and install `rtk`:

**macOS/Linux:**
```bash
curl -sSL https://raw.githubusercontent.com/rtk-ai/rtk/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/rtk-ai/rtk/main/install.ps1 | iex
```

### 2. Add to your Project
Simply copy the contents of the `rtk-vs-code-template/` directory to the root of your project:
* `.github/copilot-instructions.md` - Instructs the Agent when analyzing files.
* `.vscode/settings.json` - Globally enforces RTK usage across all VS Code chat commands.

Alternatively, via Command Line inside your project directory:
```bash
mkdir -p .vscode .github
curl -sSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/rtk-vscode-setup/main/rtk-vs-code-template/.github/copilot-instructions.md -o .github/copilot-instructions.md
curl -sSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/rtk-vscode-setup/main/rtk-vs-code-template/.vscode/settings.json -o .vscode/settings.json
```

### 3. See it in Action
Open VS Code GitHub Copilot Chat (or Edits) and ask:
> "Run my tests and fix the failure"

Copilot will automatically run `rtk npm test` or `rtk cargo test`, receiving only the intelligently filtered output.
