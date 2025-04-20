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
    Requirement : Run as current user or deploy via GPO
    Reference   : DISA STIG WN10-CC-000295 / V-220846
#>

Write-Host "Configuring RSS feed settings to prevent attachment downloads..." -ForegroundColor Cyan

$regPath = "HKCU:\Software\Policies\Microsoft\Internet Explorer\Feeds"
$regName = "DisableEnclosureDownload"
$regValue = 1

# Create the registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Write-Host "Setting '$regName' to '$regValue'..." -ForegroundColor Yellow
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Confirm the change
$confirm = Get-ItemProperty -Path $regPath -Name $regName
if ($confirm.$regName -eq $regValue) {
    Write-Host "✅ RSS attachment downloads are now disabled." -ForegroundColor Green
} else {
    Write-Host "❌ Failed to apply setting. Please verify manually." -ForegroundColor Red
}

Write-Host "No restart is typically required, but restarting Internet Explorer or the system may ensure full enforcement." -ForegroundColor Cyan
