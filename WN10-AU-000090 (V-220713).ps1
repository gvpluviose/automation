<#
.SYNOPSIS
    Configures auditing for Removable Storage object access.

.DESCRIPTION
    Implements STIG WN10-AU-000090 (V-220713) by enabling auditing
    of successful access to removable storage devices using auditpol.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-AU-000090 / V-220713
#>

# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Display existing setting for reference
Write-Host "`n🔎 Current setting for Removable Storage:" -ForegroundColor Cyan
auditpol /get /subcategory:"Removable Storage"

# Apply the Success audit policy
Write-Host "`n🔧 Applying policy: Enabling 'Success' for Removable Storage..." -ForegroundColor Yellow
$auditResult = & auditpol /set /subcategory:"Removable Storage" /success:enable 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Successfully enabled 'Success' auditing for Removable Storage." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply policy. Details:" -ForegroundColor Red
    Write-Host $auditResult
}

# Verify updated setting
Write-Host "`n📋 Updated setting for Removable Storage:" -ForegroundColor Cyan
auditpol /get /subcategory:"Removable Storage"
