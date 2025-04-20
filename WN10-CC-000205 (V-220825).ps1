<#
.SYNOPSIS
    Configures Windows 10 telemetry to meet STIG requirement (V-220825 / WN10-CC-000205).

.DESCRIPTION
    Ensures that the Windows telemetry level is not set to "Full" (level 3), 
    which is prohibited under security guidance. The script sets it to the most 
    restrictive supported level.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Run as Administrator
    Reference   : DISA STIG WN10-CC-000205
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script must be run as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Configuring Windows Telemetry settings for STIG compliance..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$regName = "AllowTelemetry"
$telemetryLevel = 1  # Set to 0 if you're using Enterprise/Education for tighter control

# Check edition (for optional tighter setting)
$osEdition = (Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU
$enterpriseSKUs = @(4, 27, 121, 125, 161, 175)  # Known Enterprise/Education SKUs

if ($enterpriseSKUs -contains $osEdition) {
    $telemetryLevel = 0
    Write-Host "Detected Enterprise/Education edition. Setting telemetry to 'Security' (0)." -ForegroundColor Green
} else {
    Write-Host "Detected standard edition. Setting telemetry to 'Basic' (1)." -ForegroundColor Yellow
}

# Create the registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the telemetry level
Write-Host "Setting telemetry level to $telemetryLevel at $regPath\$regName" -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $telemetryLevel -Type DWord

# Confirm the change
$confirm = Get-ItemProperty -Path $regPath -Name $regName
if ($confirm.$regName -eq $telemetryLevel) {
    Write-Host "✅ Telemetry level successfully set to $telemetryLevel." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply telemetry level. Please check permissions and try again." -ForegroundColor Red
}

Write-Host "A restart may be required for changes to fully take effect." -ForegroundColor Cyan
