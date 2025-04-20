<#
.SYNOPSIS
    Enables failure auditing for User Account Management.

.DESCRIPTION
    Applies STIG WN10-AU-000035 by enabling the 'Audit User Account Management' policy with 'Failure' using auditpol.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-21
    Must run as : Administrator
    Reference   : STIG WN10-AU-000035 / V-220716
#>

# Ensure Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Show current setting
Write-Host "`n🔍 Checking current audit setting for 'User Account Management'..." -ForegroundColor Cyan
auditpol /get /subcategory:"User Account Management"

# Apply the 'Failure' audit policy
Write-Host "`n🔧 Enabling 'Failure' auditing for User Account Management..." -ForegroundColor Yellow
$auditResult = & auditpol /set /subcategory:"User Account Management" /failure:enable 2>&1

# Check if command succeeded
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Policy applied: 'Failure' auditing is now enabled for User Account Management." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the policy. Output:" -ForegroundColor Red
    Write-Host $auditResult
}

# Confirm updated setting
Write-Host "`n📋 Verifying updated setting..." -ForegroundColor Cyan
auditpol /get /subcategory:"User Account Management"
