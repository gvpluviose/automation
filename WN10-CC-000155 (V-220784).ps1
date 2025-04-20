<#
.SYNOPSIS
    Disables Solicited Remote Assistance on Windows 10.

.DESCRIPTION
    Applies STIG requirement WN10-CC-000155 (V-220784) by disabling 
    the “Configure Solicited Remote Assistance” policy via the registry.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-CC-000155 / V-220784
#>

# Ensure admin rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
     [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "🔧 Disabling Solicited Remote Assistance..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$regName = "fAllowToGetHelp"
$desiredValue = 0

# Create the registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "📁 Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -Type DWord

# Confirm the setting
$current = Get-ItemProperty -Path $regPath -Name $regName
if ($current.$regName -eq $desiredValue) {
    Write-Host "✅ Solicited Remote Assistance is now disabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to disable Solicited Remote Assistance." -ForegroundColor Red
}

Write-Host "ℹ️ A reboot or 'gpupdate /force' may be required to fully apply the setting." -ForegroundColor Cyan
