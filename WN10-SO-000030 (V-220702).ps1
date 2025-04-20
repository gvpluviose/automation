<#
.SYNOPSIS
    Enables audit policy subcategories in Windows 10 for STIG compliance.

.DESCRIPTION
    This script ensures that Windows is configured to use advanced audit policy subcategories 
    rather than the older legacy audit settings. This is required by STIG ID: WN10-SO-000030.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : DISA STIG WN10-SO-000030 / V-220702
#>

# Check for admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script must be run as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Enabling audit policy subcategories..." -ForegroundColor Cyan

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regName = "SCENoApplyLegacyAuditPolicy"
$regValue = 1

# Ensure the registry key exists
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry key: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Write-Host "Setting '$regName' to '$regValue'..." -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Confirm the setting
$check = Get-ItemProperty -Path $regPath -Name $regName
if ($check.$regName -eq $regValue) {
    Write-Host "✅ Audit subcategories are now enabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply setting. Please check manually." -ForegroundColor Red
}

Write-Host "You may need to restart or refresh policies for the change to take effect." -ForegroundColor Cyan
