<#
.SYNOPSIS
    Disables HTTP printing in Windows.

.DESCRIPTION
    Implements STIG WN10-CC-000110 (V-220776) by enabling the policy
    "Turn off printing over HTTP" via registry.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-CC-000110 / V-220776
#>

# Check for admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "🖨️ Disabling HTTP printing..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$regName = "DisableHTTPPrinting"
$desiredValue = 1

# Create the registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "📁 Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the setting
Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -Type DWord

# Verify and confirm
$current = Get-ItemProperty -Path $regPath -Name $regName
if ($current.$regName -eq $desiredValue) {
    Write-Host "✅ HTTP printing has been disabled successfully." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting." -ForegroundColor Red
}

Write-Host "ℹ️ A restart or 'gpupdate /force' may be required for changes to take effect." -ForegroundColor Cyan
