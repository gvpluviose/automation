<#
.SYNOPSIS
    Disables slide show on the Windows lock screen.

.DESCRIPTION
    Implements STIG WN10-CC-000010 (V-220776) by enabling the policy 
    "Prevent enabling lock screen slide show" via registry.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-CC-000010 / V-220776
#>

# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
     [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "🎨 Disabling lock screen slideshow..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$regName = "NoLockScreenSlideshow"
$regValue = 1

# Create registry path if missing
if (-not (Test-Path $regPath)) {
    Write-Host "📁 Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the setting
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Validate the setting
$current = Get-ItemProperty -Path $regPath -Name $regName
if ($current.$regName -eq $regValue) {
    Write-Host "✅ Lock screen slideshow successfully disabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting. Please check manually." -ForegroundColor Red
}

Write-Host "ℹ️ A restart or 'gpupdate /force' may be needed for the change to take full effect." -ForegroundColor Cyan
