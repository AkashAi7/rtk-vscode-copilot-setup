#!/usr/bin/env bash
echo "🚀 Welcome to the RTK GitHub Copilot Integration Setup!"
echo ""
echo "This script configures GitHub Copilot in VS Code to use 'rtk' for terminal commands,"
echo "saving 60-90% of LLM tokens when diagnosing build/test failures."
echo ""
echo "Where would you like to install these Copilot instructions?"
echo "  [G] Globally    - Applies to ALL your VS Code projects on this machine."
echo "  [P] Per-Project - Applies ONLY to the current directory (creates .vscode and .github folders)."
echo ""
read -p "Enter your choice (G/P): " choice

if [[ "$choice" =~ ^[Gg]$ ]]; then
    echo -e "\n🔧 Configuring Globally..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    else
        VSCODE_DIR="$HOME/.config/Code/User"
    fi
    mkdir -p "$VSCODE_DIR"
    SETTINGS_FILE="$VSCODE_DIR/settings.json"
    
    if [ ! -f "$SETTINGS_FILE" ]; then
        echo "{}" > "$SETTINGS_FILE"
    fi

    # Using Python to safely modify the settings.json
    python3 -c '
import json, sys, os
file_path = sys.argv[1]
try:
    with open(file_path, "r") as f:
        data = json.load(f)
except Exception:
    data = {}

instructions = data.get("github.copilot.chat.codeGeneration.instructions", [])
new_inst = {"text": "Always prefix terminal commands with tk (e.g., tk npm test or tk git status) to compress output and save tokens. If rtk is not installed, remind the user to install it."}

# Prevent duplicates
filtered = [i for i in instructions if "Always prefix terminal commands with tk" not in i.get("text", "")]
filtered.append(new_inst)

data["github.copilot.chat.codeGeneration.instructions"] = filtered

with open(file_path, "w") as f:
    json.dump(data, f, indent=4)
' "$SETTINGS_FILE"

    echo "✅ Global configuration successful! Restart VS Code if open."
elif [[ "$choice" =~ ^[Pp]$ ]]; then
    echo -e "\n🔧 Configuring Per-Project (Current Directory)..."
    mkdir -p .vscode .github
    echo "Downloading instructions..."
    curl -sSL "https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.github/copilot-instructions.md" -o .github/copilot-instructions.md
    curl -sSL "https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.vscode/settings.json" -o .vscode/settings.json
    echo "✅ Per-Project configuration successful! Files added to .vscode/ and .github/"
else
    echo "❌ Invalid choice. Exiting."
fi

echo ""
echo "Don't forget to ensure RTK is installed on your system:"
echo "curl -sSL https://raw.githubusercontent.com/rtk-ai/rtk/main/install.sh | bash"
