<#
.SYNOPSIS
    Disables the camera on the Windows lock screen to comply with STIG requirement WN10-CC-000005 (V-220792).

.DESCRIPTION
    This script configures the system to prevent access to the camera on the lock screen by setting 
    the 'NoLockScreenCamera' registry value to 1 under:
        HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization

    This helps meet the DISA STIG compliance requirement for securing the Windows lock screen.

.NOTES
    Author      : Gervaisson Pluviose
    Date        : 2025-04-20
    OS          : Windows 10
    STIG ID     : WN10-CC-000005
    Vuln ID     : V-220792
    Fix Version : 1.0

    Run this script with administrator privileges.

.EXAMPLE
    PS C:\> .\Disable-LockScreenCamera.ps1

    Applies the lock screen camera restriction immediately.
#>

# Ensure the script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Warning "You must run this script as an Administrator."
    exit 1
}

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$propertyName = "NoLockScreenCamera"
$propertyValue = 1

# Create the registry key if it doesn't exist
if (-not (Test-Path $registryPath)) {
    Write-Output "Creating registry path: $registryPath"
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Write-Output "Setting '$propertyName' to '$propertyValue' under '$registryPath'"
Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -Type DWord

# Confirm the value was set
$currentValue = Get-ItemPropertyValue -Path $registryPath -Name $propertyName
if ($currentValue -eq $propertyValue) {
    Write-Output "Success: Camera access on the lock screen has been disabled."
} else {
    Write-Warning "Failed to apply setting. Current value is $currentValue."
}
