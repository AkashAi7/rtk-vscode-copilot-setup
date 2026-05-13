Write-Host "🗑️ Welcome to the RTK GitHub Copilot Integration Uninstaller!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Where would you like to remove the Copilot instructions from?"
Write-Host "  [G] Globally    - Removes from ALL your VS Code projects on this machine."
Write-Host "  [P] Per-Project - Removes ONLY from the current directory."
Write-Host ""

$choice = Read-Host "Enter your choice (G/P)"

if ($choice -match "^[Gg]") {
    Write-Host "
🔧 Uninstalling Globally..." -ForegroundColor Yellow
    $vsCodeSettingsDir = Join-Path $env:APPDATA "Code\User"
    $settingsFile = Join-Path $vsCodeSettingsDir "settings.json"
    
    if (Test-Path $settingsFile) {
        $settings = Get-Content -Raw $settingsFile | ConvertFrom-Json
        if ($null -ne $settings."github.copilot.chat.codeGeneration.instructions") {
            # Filter out our specific instruction
            $newInstructions = @()
            foreach ($inst in $settings."github.copilot.chat.codeGeneration.instructions") {
                if ($inst.text -notmatch "Always prefix terminal commands with `rtk`") {
                    $newInstructions += $inst
                }
            }
            
            if ($newInstructions.Count -eq 0) {
                $settings.PSObject.Properties.Remove("github.copilot.chat.codeGeneration.instructions")
            } else {
                $settings."github.copilot.chat.codeGeneration.instructions" = $newInstructions
            }
            
            $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
            Write-Host "✅ Global uninstall successful!" -ForegroundColor Green
        } else {
            Write-Host "ℹ️ No global instructions found to remove." -ForegroundColor Yellow
        }
    }
}
elseif ($choice -match "^[Pp]") {
    Write-Host "
🔧 Uninstalling Per-Project (Current Directory)..." -ForegroundColor Yellow
    
    $mdPath = ".github/copilot-instructions.md"
    if (Test-Path $mdPath) {
        Remove-Item $mdPath -Force
        Write-Host "🗑️ Removed $mdPath"
    }
    
    $settingsPath = ".vscode/settings.json"
    if (Test-Path $settingsPath) {
        $settings = Get-Content -Raw $settingsPath | ConvertFrom-Json
        if ($null -ne $settings."github.copilot.chat.codeGeneration.instructions") {
            $newInstructions = @()
            foreach ($inst in $settings."github.copilot.chat.codeGeneration.instructions") {
                if ($inst.text -notmatch "Always prefix terminal commands with `rtk`") {
                    $newInstructions += $inst
                }
            }
            if ($newInstructions.Count -eq 0) {
                $settings.PSObject.Properties.Remove("github.copilot.chat.codeGeneration.instructions")
            } else {
                $settings."github.copilot.chat.codeGeneration.instructions" = $newInstructions
            }
            
            if ($settings.PSObject.Properties.Count -eq 0) {
                Remove-Item $settingsPath -Force
                Write-Host "🗑️ Removed empty $settingsPath"
            } else {
                $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
                Write-Host "🗑️ Removed instructions from $settingsPath"
            }
        }
    }
    Write-Host "✅ Per-Project uninstall successful!" -ForegroundColor Green
}
else {
    Write-Host "❌ Invalid choice. Exiting." -ForegroundColor Red
}
