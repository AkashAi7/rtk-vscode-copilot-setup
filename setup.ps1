Write-Host "🚀 Welcome to the RTK GitHub Copilot Integration Setup!" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script configures GitHub Copilot in VS Code to use 'rtk' for terminal commands,"
Write-Host "saving 60-90% of LLM tokens when diagnosing build/test failures."
Write-Host ""
Write-Host "Where would you like to install these Copilot instructions?"
Write-Host "  [G] Globally    - Applies to ALL your VS Code projects on this machine."
Write-Host "  [P] Per-Project - Applies ONLY to the current directory (creates .vscode and .github folders)."
Write-Host ""

$choice = Read-Host "Enter your choice (G/P)"

if ($choice -match "^[Gg]") {
    Write-Host "
🔧 Configuring Globally..." -ForegroundColor Yellow
    $vsCodeSettingsDir = Join-Path $env:APPDATA "Code\User"
    $settingsFile = Join-Path $vsCodeSettingsDir "settings.json"
    
    if (-not (Test-Path $vsCodeSettingsDir)) {
        New-Item -ItemType Directory -Force -Path $vsCodeSettingsDir | Out-Null
    }

    $settings = @{}
    if (Test-Path $settingsFile) {
        $settings = Get-Content -Raw $settingsFile | ConvertFrom-Json
    }

    $instruction = [PSCustomObject]@{
        text = "Always prefix terminal commands with `rtk` (e.g., `rtk npm test` or `rtk git status`) to compress output and save tokens. If rtk is not installed, remind the user to install it."
    }

    $settings["github.copilot.chat.codeGeneration.instructions"] = @($instruction)
    
    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
    Write-Host "✅ Global configuration successful! Restart VS Code if open." -ForegroundColor Green
}
elseif ($choice -match "^[Pp]") {
    Write-Host "
🔧 Configuring Per-Project (Current Directory)..." -ForegroundColor Yellow
    if (-not (Test-Path ".vscode")) { New-Item -ItemType Directory -Force -Path ".vscode" | Out-Null }
    if (-not (Test-Path ".github")) { New-Item -ItemType Directory -Force -Path ".github" | Out-Null }

    # Download files safely using Invoke-RestMethod
    Write-Host "Downloading instructions..."
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.github/copilot-instructions.md" -OutFile ".github/copilot-instructions.md"
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.vscode/settings.json" -OutFile ".vscode/settings.json"

    Write-Host "✅ Per-Project configuration successful! Files added to .vscode/ and .github/" -ForegroundColor Green
}
else {
    Write-Host "❌ Invalid choice. Exiting." -ForegroundColor Red
}

Write-Host ""
Write-Host "Don't forget to ensure RTK is installed on your system:" -ForegroundColor Cyan
Write-Host "irm https://raw.githubusercontent.com/rtk-ai/rtk/main/install.ps1 | iex" -ForegroundColor White
