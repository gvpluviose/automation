<#
.SYNOPSIS
    Disables attachment downloads from RSS feeds in Internet Explorer.

.DESCRIPTION
    This script configures the registry to prevent automatic downloading of attachments 
    from RSS feeds, ensuring compliance with STIG ID: WN10-CC-000295.

.NOTES
    Author      : Gervaisson Pluviose
    Created     : 2025-04-20
    Last Updated: 2025-04-20
    Requirement : Must be run as Administrator
    Reference   : DISA STIG WN10-CC-000295 / V-220846
#>

# Ensure the script is running with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
     [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Configuring policy to prevent downloading of RSS enclosures..." -ForegroundColor Cyan

$regPath = "HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds"
$regName = "DisableEnclosureDownload"
$regValue = 1

# Create registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set the value
Write-Host "Setting '$regName' to '$regValue'" -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Verify result
$current = Get-ItemProperty -Path $regPath -Name $regName
if ($current.$regName -eq $regValue) {
    Write-Host "✅ RSS enclosure downloads are now blocked." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply the setting. Please verify manually." -ForegroundColor Red
}

Write-Host "Done. You may need to restart or force a policy refresh (gpupdate /force) for changes to take full effect." -ForegroundColor Cyan
