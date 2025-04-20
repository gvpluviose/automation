<#
.SYNOPSIS
    Disables Basic authentication for the WinRM client to comply with WN10-CC-000330.

.DESCRIPTION
    This script configures the policy setting to disable Basic authentication for the WinRM client
    by modifying the corresponding registry key.

.NOTES
    Author      : Gervaisson Pluviose
    Date        : 2025-04-21
    STIG ID     : WN10-CC-000330
    Must run as : Administrator
#>

# Check for Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n🔧 Applying STIG Fix: Disable Basic Authentication for WinRM Client..." -ForegroundColor Yellow

# Registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
$regName = "AllowBasic"
$desiredValue = 0

# Create registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "🆕 Created registry path: $regPath" -ForegroundColor Cyan
}

# Set the value
Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -Type DWord
Write-Host "✅ Basic authentication for WinRM Client has been disabled." -ForegroundColor Green

# Confirm
$current = Get-ItemProperty -Path $regPath -Name $regName
Write-Host "🔎 Confirmed: AllowBasic = $($current.AllowBasic)`n" -ForegroundColor Cyan
