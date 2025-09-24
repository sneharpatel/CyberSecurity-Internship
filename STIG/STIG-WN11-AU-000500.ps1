<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Sneha Patel
    LinkedIn        : linkedin.com/in/sneha-p-040144133/
    GitHub          : github.com/sneharpatel
    Date Created    : 2025-09-24
    Last Modified   : 2025-09-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AU-000500.ps1 
#>


# Define the registery path and value

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$propertyName = "MaxSize"
$propertyValue = 0x8000  # 32768 in decimal (KB)

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Create or update the MaxSize value
if (Get-ItemProperty -Path $regPath -Name $propertyName -ErrorAction SilentlyContinue) {
    Set-ItemProperty -Path $regPath -Name $propertyName -Value $propertyValue
} else {
    New-ItemProperty -Path $regPath -Name $propertyName -Value $propertyValue -PropertyType DWord
}

Write-Output "Registry value '$propertyName' set to $propertyValue (0x$($propertyValue.ToString('X'))) under $regPath"
