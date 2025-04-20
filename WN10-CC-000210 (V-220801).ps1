<#
.SYNOPSIS
    Enables Windows Defender SmartScreen for File Explorer with 'Warn and prevent bypass' setting.

.DESCRIPTION
    Applies STIG WN10-CC-000210 (V-220801) by configuring registry keys
    that enable SmartScreen and prevent users from bypassing warnings.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Run as Administrator
    Reference   : STIG WN10-CC-000210 / V-220801
#>

# Ensure administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "🛡️ Enabling Windows Defender SmartScreen for Explorer..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$smartScreenValue = 1
$smartScreenLevel = "Block"  # 'Block' = Warn and prevent bypass

# Create registry path if missing
if (-not (Test-Path $regPath)) {
    Write-Host "📁 Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set registry values
Set-ItemProperty -Path $regPath -Name "EnableSmartScreen" -Value $smartScreenValue -Type DWord
Set-ItemProperty -Path $regPath -Name "ShellSmartScreenLevel" -Value $smartScreenLevel -Type String

# Confirm settings
$confirm = Get-ItemProperty -Path $regPath
if ($confirm.EnableSmartScreen -eq 1 -and $confirm.ShellSmartScreenLevel -eq "Block") {
    Write-Host "✅ Windows Defender SmartScreen for Explorer is enabled with 'Warn and prevent bypass'." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply SmartScreen configuration." -ForegroundColor Red
}

Write-Host "ℹ️ You may need to restart or run 'gpupdate /force' for changes to take effect." -ForegroundColor Cyan
