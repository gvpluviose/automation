<#
.SYNOPSIS
    Disables AutoPlay for all drives to enhance security.

.DESCRIPTION
    Implements STIG WN10-CC-000190 (V-220788) by configuring registry settings
    to prevent AutoPlay from launching automatically on any drive.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-CC-000190 / V-220788
#>

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "🔒 Disabling AutoPlay for all drives..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regName = "NoDriveTypeAutoRun"
$desiredValue = 255  # 0xFF disables AutoPlay on all drive types

# Create registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "📁 Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the setting
Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -Type DWord

# Verify
$current = Get-ItemProperty -Path $regPath -Name $regName
if ($current.$regName -eq $desiredValue) {
    Write-Host "✅ AutoPlay has been disabled for all drives." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply AutoPlay settings." -ForegroundColor Red
}

Write-Host "ℹ️ You may need to run 'gpupdate /force' or reboot for full effect." -ForegroundColor Cyan
