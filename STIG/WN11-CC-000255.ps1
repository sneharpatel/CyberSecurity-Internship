<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Sneha Patel
    LinkedIn        : linkedin.com/in/sneha-p-040144133/
    GitHub          : github.com/sneharpatel
    Date Created    : 2025-09-29
    Last Modified   : 2025-09-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000255 

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000255.ps1 
#>
# STIG ID: WN11-CC-000255
# Configure "Use a hardware security device" to Enabled (RequireSecurityDevice = 1)

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork"
$valueName = "RequireSecurityDevice"
$valueData = 1

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty -Path $regPath -Name $valueName -Value $valueData -PropertyType DWord -Force | Out-Null

Write-Host "STIG WN11-CC-000255 applied. Registry updated:"
Write-Host "$regPath\$valueName = $valueData"


<# 
Verification: 

After running, check with:

Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork" | Select-Object RequireSecurityDevice

It should return:

RequireSecurityDevice : 1

Notes:

This enforces hardware TPM / security device requirement.

On virtual desktops (VDI) that reset on logoff, this STIG is marked Not Applicable (NA).

Equivalent GUI path:
gpedit.msc → Computer Configuration → Administrative Templates → Windows Components → Windows Hello for Business → Use a hardware security device → Enabled.

#>
