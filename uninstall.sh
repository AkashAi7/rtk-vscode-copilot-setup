#!/usr/bin/env bash
echo "🗑️ Welcome to the RTK GitHub Copilot Integration Uninstaller!"
echo ""
echo "Where would you like to remove the Copilot instructions from?"
echo "  [G] Globally    - Removes from ALL your VS Code projects on this machine."
echo "  [P] Per-Project - Removes ONLY from the current directory."
echo ""
read -p "Enter your choice (G/P): " choice

if [[ "$choice" =~ ^[Gg]$ ]]; then
    echo -e "\n🔧 Uninstalling Globally..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    else
        VSCODE_DIR="$HOME/.config/Code/User"
    fi
    SETTINGS_FILE="$VSCODE_DIR/settings.json"
    
    if [ -f "$SETTINGS_FILE" ]; then
        python3 -c '
import json, sys, os
file_path = sys.argv[1]
try:
    with open(file_path, "r") as f:
        data = json.load(f)
except Exception:
    sys.exit(0)

if "github.copilot.chat.codeGeneration.instructions" in data:
    instructions = data["github.copilot.chat.codeGeneration.instructions"]
    filtered = [i for i in instructions if "Always prefix terminal commands with tk" not in i.get("text", "")]
    
    if not filtered:
        del data["github.copilot.chat.codeGeneration.instructions"]
    else:
        data["github.copilot.chat.codeGeneration.instructions"] = filtered
        
    with open(file_path, "w") as f:
        json.dump(data, f, indent=4)
print("✅ Global uninstall successful!")
' "$SETTINGS_FILE"
    else
        echo "ℹ️ No global instructions found to remove."
    fi
elif [[ "$choice" =~ ^[Pp]$ ]]; then
    echo -e "\n🔧 Uninstalling Per-Project (Current Directory)..."
    
    if [ -f ".github/copilot-instructions.md" ]; then
        rm -f .github/copilot-instructions.md
        echo "🗑️ Removed .github/copilot-instructions.md"
    fi
    
    if [ -f ".vscode/settings.json" ]; then
        python3 -c '
import json, sys, os
file_path = sys.argv[1]
try:
    with open(file_path, "r") as f:
        data = json.load(f)
except Exception:
    sys.exit(0)

if "github.copilot.chat.codeGeneration.instructions" in data:
    instructions = data["github.copilot.chat.codeGeneration.instructions"]
    filtered = [i for i in instructions if "Always prefix terminal commands with tk" not in i.get("text", "")]
    
    if not filtered:
        del data["github.copilot.chat.codeGeneration.instructions"]
    else:
        data["github.copilot.chat.codeGeneration.instructions"] = filtered
        
    if not data:
        os.remove(file_path)
    else:
        with open(file_path, "w") as f:
            json.dump(data, f, indent=4)
' ".vscode/settings.json"
        echo "🗑️ Removed instructions from .vscode/settings.json"
    fi
    echo "✅ Per-Project uninstall successful!"
else
    echo "❌ Invalid choice. Exiting."
fi
