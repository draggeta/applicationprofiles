Write-Output "### Windows Security"

# Enable Controlled folder access
Write-Output "Enabling controlled folder access"
Set-MpPreference -EnableControlledFolderAccess Enabled

Write-Output "Allowing apps through controlled folder access"
foreach ($process in $controlledFolderAccessProcesses) {
    Add-MpPreference -ControlledFolderAccessAllowedApplications (Get-Command -Name $process).Source
}

# Enable tamper protection (cannot do it via module yet)
Write-Output "Enabling tamper protection"
$mpRegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
if ((Get-ItemPropertyValue $mpRegistryKeyPath -Name TamperProtection) -lt 1) {
    Set-ItemProperty -Path $mpRegistryKeyPath -Name "TamperProtection" -Value 5
}

# Virtualization based security (Core Isolation/Memory Integrity)
Write-Output "Enabling core isolation"
$vbsRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios"
if (-not (Test-Path $vbsRegistryKeyPath)) {
    New-Item -Path $vbsRegistryKeyPath -Name "HypervisorEnforcedCodeIntegrity" -Value 1 -Force
}
else {
    Set-ItemProperty -Path $vbsRegistryKeyPath -Name "HypervisorEnforcedCodeIntegrity" -Value 1
}
