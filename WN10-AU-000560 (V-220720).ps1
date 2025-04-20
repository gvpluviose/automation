<#
.SYNOPSIS
    Enables auditing of successful Other Logon/Logoff events.

.DESCRIPTION
    Applies STIG WN10-AU-000560 (V-220720) by enabling audit policy for 
    'Other Logon/Logoff Events' with Success using auditpol.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-AU-000560 / V-220720
#>

# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Display current audit setting
Write-Host "`n🔍 Checking current setting for 'Other Logon/Logoff Events'..." -ForegroundColor Cyan
auditpol /get /subcategory:"Other Logon/Logoff Events"

# Apply the Success audit policy
Write-Host "`n🔧 Applying: Enabling 'Success' for Other Logon/Logoff Events..." -ForegroundColor Yellow
$auditResult = & auditpol /set /subcategory:"Other Logon/Logoff Events" /success:enable 2>&1

# Check result
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Audit policy successfully applied." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply audit policy. Details:" -ForegroundColor Red
    Write-Host $auditResult
}

# Verify updated setting
Write-Host "`n📋 Verifying updated setting:" -ForegroundColor Cyan
auditpol /get /subcategory:"Other Logon/Logoff Events"
