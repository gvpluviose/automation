<#
.SYNOPSIS
    Disables local drive redirection in Remote Desktop sessions.

.DESCRIPTION
    This script configures the registry to prevent local drives from being shared with
    Remote Desktop Session Hosts, enforcing STIG ID: WN10-CC-000275 / V-220844.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : DISA STIG WN10-CC-000275 / V-220844
#>

# Check admin privilege
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Applying policy to prevent local drive redirection in RDP sessions..." -ForegroundColor Cyan

$regPath = "HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services"
$regName = "fDisableCdm"
$regValue = 1

# Create registry path if missing
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set the required value
Write-Host "Disabling local drive redirection by setting '$regName' to '$regValue'..." -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify result
$result = Get-ItemProperty -Path $regPath -Name $regName
if ($result.$regName -eq $regValue) {
    Write-Host "✅ Local drive redirection has been successfully disabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting. Please check manually." -ForegroundColor Red
}

Write-Host "A system reboot or policy refresh may be required to fully apply the changes." -ForegroundColor Cyan
