<#
.SYNOPSIS
    Disables the Windows Hello convenience PIN sign-in feature on Windows 10.

.DESCRIPTION
    This script sets a registry key to disable the use of convenience PINs (Windows Hello for Business).
    This is required to comply with STIG ID: WN10-CC-000370 / V-220856.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : DISA STIG WN10-CC-000370
#>

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script must be run as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Starting process to disable Windows Hello PIN sign-in..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regName = "AllowDomainPINLogon"
$regValue = 0

# Create the registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the setting to disable PIN login
Write-Host "Disabling convenience PIN by setting '$regName' to '$regValue'..." -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Confirm the change
$current = Get-ItemProperty -Path $regPath -Name $regName
if ($current.$regName -eq $regValue) {
    Write-Host "✅ Convenience PIN sign-in has been successfully disabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to disable convenience PIN. Please verify manually." -ForegroundColor Red
}

Write-Host "Restart or log off may be required for the changes to take effect." -ForegroundColor Cyan
