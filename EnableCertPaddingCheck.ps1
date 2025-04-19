<#
.SYNOPSIS
    Enables certificate padding check for both 64-bit and 32-bit (WOW6432Node) applications
    by setting the EnableCertPaddingCheck registry key.

.DESCRIPTION
    This script sets the EnableCertPaddingCheck registry value under both:
    - HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Wintrust\Config
    - HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config

    This enforces stricter X.509 certificate validation, improving security for applications
    that rely on Windows cryptographic APIs.

.NOTES
    Author: Gervaisson Pluviose
    Date:   2025-04-19
    Tested on: Windows Server 2019 (x64)

#>

# Define registry paths
$paths = @(
    "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config",                  # 64-bit
    "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config"       # 32-bit (WOW64)
)

foreach ($path in $paths) {
    try {
        # Ensure the registry path exists
        if (-not (Test-Path $path)) {
            Write-Host "Creating registry path: $path"
            New-Item -Path $path -Force | Out-Null
        }

        # Set the EnableCertPaddingCheck DWORD value to 1
        Write-Host "Setting EnableCertPaddingCheck=1 at: $path"
        New-ItemProperty -Path $path `
                         -Name "EnableCertPaddingCheck" `
                         -PropertyType DWord `
                         -Value 1 `
                         -Force | Out-Null
    }
    catch {
        Write-Warning "Failed to set registry key at $path. Error: $_"
    }
}

Write-Host "`n✅ Certificate padding check has been enabled successfully for both registry paths."
Write-Host "🚨 A system reboot is recommended for changes to take full effect."
