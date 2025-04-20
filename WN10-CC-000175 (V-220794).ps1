<#
.SYNOPSIS
    Disables the Application Compatibility Inventory Collector.

.DESCRIPTION
    Applies STIG WN10-CC-000175 by setting the 'Turn off Inventory Collector' 
    policy to 'Enabled', preventing data from being collected and sent to Microsoft.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Must run as : Administrator
    Reference   : STIG WN10-CC-000175 / V-220794
#>

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n🔧 Disabling Application Compatibility Inventory Collector..." -ForegroundColor Yellow

# Registry path for the setting
$regPath = "HKLM:\Software\Policies\Microsoft\Windows\AppCompat"
$regName = "DisableInventory"
$regValue = 1  # 1 = Enabled (i.e., inventory collection is turned off)

# Create key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Apply the setting
New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType DWORD -Force | Out-Null

# Confirm the change
$currentValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ($currentValue -eq $regValue) {
    Write-Host "✅ Inventory Collector has been disabled successfully." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting." -ForegroundColor Red
}

Write-Host "`n📎 Registry path: $regPath" -ForegroundColor Cyan
Write-Host "🔒 Policy Name: Turn off Inventory Collector"
Write-Host "📝 Value: Enabled (DWORD 1)"
