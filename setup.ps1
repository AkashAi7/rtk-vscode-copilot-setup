Write-Host "🚀 Welcome to the RTK GitHub Copilot Integration Setup!" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will completely set up RTK for you:"
Write-Host " 1. Download and install the actual 'rtk' CLI tool silently."
Write-Host " 2. Configure GitHub Copilot in VS Code to use it to save tokens."
Write-Host ""

# 1. Install RTK Binary Seamlessly
Write-Host "📥 Installing RTK CLI tool..." -ForegroundColor Yellow
$rtkDir = Join-Path $env:LOCALAPPDATA "rtk"
if (-not (Test-Path $rtkDir)) { New-Item -ItemType Directory -Force -Path $rtkDir | Out-Null }

try {
    # Get latest release data
    $releaseUrl = "https://api.github.com/repos/rtk-ai/rtk/releases/latest"
    $release = Invoke-RestMethod -Uri $releaseUrl -ErrorAction Stop
    
    # Find Windows MSVC zip
    $asset = $release.assets | Where-Object { $_.name -match "x86_64-pc-windows-msvc\.zip" }
    
    if ($asset) {
        $zipPath = Join-Path $rtkDir "rtk.zip"
        Write-Host "   Downloading latest Windows release..."
        Invoke-RestMethod -Uri $asset.browser_download_url -OutFile $zipPath
        
        Write-Host "   Extracting..."
        Expand-Archive -Path $zipPath -DestinationPath $rtkDir -Force
        Remove-Item $zipPath -Force
        
        # Move executable if it's in a subfolder from the zip
        $exePaths = Get-ChildItem -Path $rtkDir -Recurse -Filter "rtk.exe"
        if ($exePaths) {
            Copy-Item -Path $exePaths[0].FullName -Destination (Join-Path $rtkDir "rtk.exe") -Force
        }
        
        # Add to PATH if not already there
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notmatch [regex]::Escape($rtkDir)) {
            [Environment]::SetEnvironmentVariable("Path", $userPath + ";" + $rtkDir, "User")
            $env:Path += ";" + $rtkDir
            Write-Host "   ✅ Added RTK to User PATH." -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️ Could not find a pre-compiled Windows zip in the latest release." -ForegroundColor Yellow
        Write-Host "   Falling back to cargo install (requires Rust)..." -ForegroundColor Yellow
        cargo install rtk-cli --locked
    }
} catch {
    Write-Host "   ⚠️ Failed to download automatically: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host "✅ RTK CLI installed successfully!
" -ForegroundColor Green


# 2. Setup VSCode Copilot Instructions
Write-Host "Where would you like to install the Copilot instructions?"
Write-Host "  [G] Globally    - Applies to ALL your VS Code projects on this machine."
Write-Host "  [P] Per-Project - Applies ONLY to the current directory."
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

    Write-Host "Downloading instructions..."
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.github/copilot-instructions.md" -OutFile ".github/copilot-instructions.md"
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/AkashAi7/rtk-vscode-copilot-setup/master/.vscode/settings.json" -OutFile ".vscode/settings.json"

    Write-Host "✅ Per-Project configuration successful! Files added to .vscode/ and .github/" -ForegroundColor Green
}
else {
    Write-Host "❌ Invalid choice. Skipping VS Code setup." -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 You are all set! The RTK CLI is installed and Copilot is configured." -ForegroundColor Green
Write-Host "(You may need to restart your terminal for the RTK command to be recognized)" -ForegroundColor Cyan
