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
    STIG-ID         : WN11-AU-000010

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AU-000010.ps1 
#>


# Run in PowerShell as Administrator

Write-Host "=== Checking WN11-SO-000030 (Force subcategory settings) ==="

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$propertyName = "SCENoApplyLegacyAuditPolicy"

$subcatEnabled = $false
if (Test-Path $regPath) {
    $value = (Get-ItemProperty -Path $regPath -Name $propertyName -ErrorAction SilentlyContinue).$propertyName
    if ($value -eq 1) {
        Write-Host "Compliant: Audit subcategory settings override category settings is ENABLED."
        $subcatEnabled = $true
    } else {
        Write-Host "NON-COMPLIANT: Audit subcategory override is DISABLED."
    }
} else {
    Write-Host "Registry key not found — check manually."
}

Write-Host "`n=== Checking WN11-AU-000010 (Credential Validation auditing) ==="

# Run AuditPol to get Credential Validation settings
$auditPolOutput = auditpol /get /subcategory:"Credential Validation"

if ($auditPolOutput -match "Success") {
    Write-Host "Compliant: Credential Validation auditing is set to Success."
} else {
    Write-Host "NON-COMPLIANT: Credential Validation auditing is NOT set to Success."
    Write-Host "To remediate, run:"
    Write-Host '  auditpol /set /subcategory:"Credential Validation" /success:enable /failure:disable'
}
