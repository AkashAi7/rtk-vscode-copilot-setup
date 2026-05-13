# RTK for GitHub Copilot & VS Code

This is a ready-to-use template that optimizes **GitHub Copilot in VS Code** using [RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk). 

tk is a proxy that filters terminal commands directly, compressing the noisy output before it reaches the Copilot LLM. This saves **60-90%** in tokens, preventing context window bloat and improving Copilot's reasoning.

## 🚀 Easy Installation Guide

### 1. Install RTK (Command Line Tool)
Open your VS Code terminal and install tk:

**macOS/Linux:**
`ash
curl -sSL https://raw.githubusercontent.com/rtk-ai/rtk/main/install.sh | bash
`

**Windows (PowerShell):**
`powershell
irm https://raw.githubusercontent.com/rtk-ai/rtk/main/install.ps1 | iex
`

### 2. Configure GitHub Copilot (Interactive Setup)

You can run our interactive CLI tool securely to set up the configuration either **Globally** (for your entire machine) or **Per-Project** (just inside a single repository).

**macOS/Linux:**
`ash
curl -sSL https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/setup.sh | bash
`

**Windows (PowerShell):**
`powershell
irm https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/setup.ps1 -OutFile setup.ps1; .\setup.ps1
`
*The script will prompt you with an interactive shell window to choose exactly how you want it applied!*

### 3. See it in Action
Open VS Code GitHub Copilot Chat and ask:
> "Run my tests to see what failed"

Copilot will automatically run tk npm test (or cargo, pytest, etc.), receiving only the intelligently filtered output.

---

## 🗑️ Uninstallation

If you ever want to remove these custom instructions, you can run the interactive uninstaller:

**macOS/Linux:**
`ash
curl -sSL https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/uninstall.sh | bash
`

**Windows (PowerShell):**
`powershell
irm https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/uninstall.ps1 -OutFile uninstall.ps1; .\uninstall.ps1
`
*It will ask if you want to remove the setup Globally or from the current Project folder.*
