<#
.SYNOPSIS
    Configures Windows to remember the last 24 passwords.

.DESCRIPTION
    Applies the STIG requirement for password history by setting the 
    "Enforce password history" policy to 24 using secedit.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : STIG WN10-AC-000020 / V-220748
#>

# Check for admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
     [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Setting password history to remember the last 24 passwords..." -ForegroundColor Cyan

# Create temporary inf file
$infPath = "$env:TEMP\password_policy.inf"
$outPath = "$env:TEMP\secedit.log"

@"
[Unicode]
Unicode=yes
[System Access]
PasswordHistorySize = 24
"@ | Set-Content -Path $infPath -Encoding Unicode

# Apply the security settings
secedit /configure /db secedit.sdb /cfg $infPath /log $outPath /quiet

# Clean up
Remove-Item $infPath -Force

Write-Host "✅ Password history policy applied. System will now remember 24 previous passwords." -ForegroundColor Green
Write-Host "You may need to refresh group policy or reboot for changes to take full effect." -ForegroundColor Yellow
