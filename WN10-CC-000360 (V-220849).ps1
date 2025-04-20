<#
.SYNOPSIS
    Disallows Digest authentication for the WinRM Client.

.DESCRIPTION
    Applies STIG WN10-CC-000360 by enabling the policy to disallow Digest authentication 
    on the WinRM Client. This setting hardens remote management security.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-21
    Must run as : Administrator
    Reference   : STIG WN10-CC-000360 / V-220849
#>

# Ensure Admin Rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n🔧 Disabling Digest Authentication for WinRM Client..." -ForegroundColor Yellow

# Registry path and values
$regPath = "HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client"
$regName = "AllowDigest"
$desiredValue = 0  # 0 = Disallow Digest authentication

# Create registry key if not present
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the value
New-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -PropertyType DWORD -Force | Out-Null

# Validate the change
$currentValue = Get-ItemPropertyValue -Path $regPath -Name $regName
if ($currentValue -eq $desiredValue) {
    Write-Host "✅ Digest Authentication has been disabled successfully for WinRM Client." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to disable Digest Authentication." -ForegroundColor Red
}

Write-Host "`n📎 Registry Path: $regPath" -ForegroundColor Cyan
Write-Host "🔒 Policy Name: Disallow Digest authentication"
Write-Host "📝 Value: Enabled (DWORD 0)"
