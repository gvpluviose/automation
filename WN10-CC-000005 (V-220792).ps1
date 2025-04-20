<#
.SYNOPSIS
    Disables the camera on the Windows 10 lock screen.

.DESCRIPTION
    This script modifies the Windows Registry to prevent users from accessing the camera 
    from the lock screen. This setting is required for compliance with STIG vulnerability 
    ID: V-220792 (WN10-CC-000005).

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    OS Support  : Windows 10
    Requirement : Run as Administrator
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Starting configuration to disable lock screen camera..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$regName = "NoLockScreenCamera"
$regValue = 1

# Create registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Write-Host "Setting '$regName' to '$regValue' at $regPath" -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Confirm the setting
$confirm = Get-ItemProperty -Path $regPath -Name $regName
if ($confirm.$regName -eq $regValue) {
    Write-Host "✅ Lock screen camera has been successfully disabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting. Please check permissions and try again." -ForegroundColor Red
}

Write-Host "You may need to restart the system or log off/log on for the change to take effect." -ForegroundColor Cyan
