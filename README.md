# RTK for GitHub Copilot & VS Code

This is a ready-to-use template that optimizes **GitHub Copilot in VS Code** using [RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk). 

tk is a proxy that filters terminal commands directly, compressing the noisy output before it reaches the Copilot LLM. This saves **60-90%** in tokens, preventing context window bloat and improving Copilot's reasoning.

## 🚀 Easy Installation Guide

### 1. Install RTK (Command Line Tool)
Open your VS Code terminal and install tk:

**macOS/Linux:**
``bash
curl -sSL https://raw.githubusercontent.com/rtk-ai/rtk/main/install.sh | bash
``

**Windows (PowerShell):**
``powershell
irm https://raw.githubusercontent.com/rtk-ai/rtk/main/install.ps1 | iex
``

### 2. Configure GitHub Copilot (Choose One Option)

You must tell GitHub Copilot to use tk via Custom Instructions. You can do this globally (for all your projects on this machine) OR per-project (to share with your team).

#### Option A: Global Configuration (Recommended for personal machines)
This applies the rule across all your VS Code workspaces automatically.
1. Open VS Code Settings (Ctrl + , or Cmd + ,).
2. Click the specific **"Open Settings (JSON)"** icon in the top right.
3. Add the following to your settings.json:
``json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "text": "Always prefix terminal commands with tk (e.g., tk npm test or tk git status) to compress output and save tokens. If rtk is not installed, remind the user to install it."
    }
  ]
}
``

#### Option B: Per-Project Configuration (Recommended for teams)
This applies the rule only to the specific project repository, meaning anyone who clones it will also get optimized token usage.
1. Run this snippet inside the root of your project:
``bash
mkdir -p .vscode .github
curl -sSL https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.github/copilot-instructions.md -o .github/copilot-instructions.md
curl -sSL https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.vscode/settings.json -o .vscode/settings.json
``

### 3. See it in Action
Open VS Code GitHub Copilot Chat and ask:
> "Run my tests to see what failed"

Copilot will automatically run tk npm test (or cargo, pytest, etc.), receiving only the intelligently filtered output.
