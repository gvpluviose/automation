<#
.SYNOPSIS
    Disables the network selection UI on the Windows logon screen.

.DESCRIPTION
    Applies STIG WN10-CC-000120 (V-220781) by enabling the policy
    "Do not display network selection UI" via registry.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-CC-000120 / V-220781
#>

# Ensure admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "🌐 Disabling network selection UI on the logon screen..." -ForegroundColor Cyan

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regName = "DontDisplayNetworkSelectionUI"
$desiredValue = 1

# Create registry path if needed
if (-not (Test-Path $regPath)) {
    Write-Host "📁 Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Apply setting
Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -Type DWord

# Verify setting
$current = Get-ItemProperty -Path $regPath -Name $regName
if ($current.$regName -eq $desiredValue) {
    Write-Host "✅ Network selection UI is now hidden on the logon screen." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting." -ForegroundColor Red
}

Write-Host "ℹ️ Run 'gpupdate /force' or restart for the change to take full effect." -ForegroundColor Cyan
