<#
.SYNOPSIS
    Prevents users from changing Windows Installer installation options.

.DESCRIPTION
    This script sets the registry key required to disable user control over installation 
    settings, in compliance with STIG ID: WN10-CC-000310.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : DISA STIG WN10-CC-000310 / V-220847
#>

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script must be run as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Enforcing policy to prevent users from changing installation options..." -ForegroundColor Cyan

$regPath = "HKLM:\Software\Policies\Microsoft\Windows\Installer"
$regName = "EnableUserControl"
$regValue = 0

# Create the registry path if necessary
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the setting
Write-Host "Setting '$regName' to '$regValue'..." -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify
$confirm = Get-ItemProperty -Path $regPath -Name $regName
if ($confirm.$regName -eq $regValue) {
    Write-Host "✅ User control over installation options has been disabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting. Please check manually." -ForegroundColor Red
}

Write-Host "Policy enforced. A restart or logoff may be required to fully apply the changes." -ForegroundColor Cyan
