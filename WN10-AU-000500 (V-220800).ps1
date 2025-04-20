 <#
.SYNOPSIS
    Sets the Application event log maximum size to 32768 KB or greater to comply with STIG requirement WN10-AU-000500 (V-220800).

.DESCRIPTION
    This script sets the maximum size of the Application event log to 32768 KB (32 MB) using the
    'wevtutil' command. This satisfies the DISA STIG requirement for event log sizing.

.NOTES
    Author      : Gervaisson Pluviose
    Date        : 2025-04-20
    OS          : Windows 10
    STIG ID     : WN10-AU-000500
    Vuln ID     : V-220800
    Fix Version : 1.2

    Run this script with administrator privileges.

.EXAMPLE
    PS C:\> .\Set-ApplicationLogSize.ps1

    Sets the Application event log size to 32768 KB and confirms success.
#>

# Ensure admin privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Error: This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

$logName = "Application"
$minSizeKB = 32768
$sizeBytes = $minSizeKB * 1024

Write-Host "Configuring '$logName' event log size to $minSizeKB KB..." -ForegroundColor Cyan

# Set log size
try {
    wevtutil sl $logName /ms:$sizeBytes
    Write-Host "Successfully set log size." -ForegroundColor Green
}
catch {
    Write-Host "Failed to set log size: $_" -ForegroundColor Red
    exit 1
}

# Verify log size
try {
    $logSettings = wevtutil gl $logName

    if ($logSettings) {
        $match = $logSettings | Select-String -Pattern "maxSize:\s+(\d+)"
        if ($match -and $match.Matches.Count -gt 0) {
            $currentSizeBytes = [int64]$match.Matches[0].Groups[1].Value
            $currentSizeKB = [math]::Round($currentSizeBytes / 1024)

            if ($currentSizeKB -ge $minSizeKB) {
                Write-Host "Success: '$logName' log size is set to $currentSizeKB KB." -ForegroundColor Green
            } else {
                Write-Host "Warning: '$logName' log size is only $currentSizeKB KB. Expected at least $minSizeKB KB." -ForegroundColor Yellow
            }
        } else {
            Write-Host "Could not find maxSize in output. Please check manually." -ForegroundColor Yellow
        }
    } else {
        Write-Host "No output from wevtutil gl $logName. Could not verify log size." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Error retrieving log settings: $_" -ForegroundColor Red
} 
