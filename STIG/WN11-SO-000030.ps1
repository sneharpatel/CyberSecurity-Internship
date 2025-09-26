<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Sneha Patel
    LinkedIn        : linkedin.com/in/sneha-p-040144133/
    GitHub          : github.com/sneharpatel
    Date Created    : 2025-09-26
    Last Modified   : 2025-09-26
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000030 

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-SO-000030.ps1 
#>


# Run in PowerShell as Administrator
# STIG ID: WN11-SO-000030
# Ensures: SCENoApplyLegacyAuditPolicy = 1

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regName = "SCENoApplyLegacyAuditPolicy"
$desiredValue = 1

Write-Host "=== Checking STIG WN11-SO-000030 ==="

# Ensure registry path exists
if (-not (Test-Path $regPath)) {
    Write-Host "Registry path $regPath not found — creating..."
    New-Item -Path $regPath -Force | Out-Null
}

# Read current value (if exists)
$currentValue = (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue).$regName

if ($null -eq $currentValue) {
    Write-Host "Registry value $regName not found — creating and setting to $desiredValue"
    New-ItemProperty -Path $regPath -Name $regName -Value $desiredValue -PropertyType DWord -Force | Out-Null
}
elseif ($currentValue -ne $desiredValue) {
    Write-Host "NON-COMPLIANT: $regName = $currentValue (expected $desiredValue). Fixing..."
    Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue
}
else {
    Write-Host "Compliant: $regName = $desiredValue"
}

# Verify result
$finalValue = (Get-ItemProperty -Path $regPath -Name $regName).$regName
Write-Host "Final Value: $regName = $finalValue"
