<#
.SYNOPSIS
    Disables Basic authentication for WinRM Service.

.DESCRIPTION
    Applies STIG WN10-CC-000345 by configuring the 'Allow Basic authentication' 
    setting for WinRM Service to 'Disabled', enhancing security against plaintext authentication.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-21
    Must run as : Administrator
    Reference   : STIG WN10-CC-000345 / V-220833
#>

# Ensure Admin Rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n🔧 Disabling Basic Authentication for WinRM Service..." -ForegroundColor Yellow

# Registry path and setting
$regPath = "HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service"
$regName = "AllowBasic"
$desiredValue = 0  # 0 = Disabled

# Ensure the key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the policy value
New-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -PropertyType DWORD -Force | Out-Null

# Verify the setting
$currentValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ($currentValue -eq $desiredValue) {
    Write-Host "✅ 'Allow Basic authentication' for WinRM has been disabled successfully." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the policy." -ForegroundColor Red
}

Write-Host "`n📎 Registry path: $regPath" -ForegroundColor Cyan
Write-Host "🔒 Policy Name: Allow Basic authentication"
Write-Host "📝 Value: Disabled (DWORD 0)"
