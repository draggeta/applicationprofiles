Write-Output "### Windows Security"

# Enable Controlled folder access
Write-Output "Enable controlled folder access"
Set-MpPreference -EnableControlledFolderAccess Enabled

Write-Output "Allow apps through controlled folder access"
$allowedProcesses = @(
    'code.cmd'
    'powershell.exe'
    'pwsh.exe'
)

foreach ($process in $allowedProcesses) {
    Add-MpPreference -ControlledFolderAccessAllowedApplications (Get-Command -Name $process).Source
}

# Enable tamper protection (cannot do it via module yet)
Write-Output "Enable tamper protection"
$mpRegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
$mpRegistryKeyValue = Get-Item -Path $mpRegistryKeyPath
if ((Get-ItemPropertyValue $mpRegistryKeyPath -Name TamperProtection) -lt 1) {
    Set-ItemProperty -Path $mpRegistryKeyPath -Name "TamperProtection" -Value 5
}


# Virtualization based security (Core Isolation/Memory Integrity)
Write-Output "Enable core isolation"
$vbsRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios"
if (-not (Test-Path $vbsRegistryKeyPath)) {
    New-Item -Path $vbsRegistryKeyPath -Name "HypervisorEnforcedCodeIntegrity" -Value 1 -Force
}
else {
    Set-ItemProperty -Path $vbsRegistryKeyPath -Name "HypervisorEnforcedCodeIntegrity" -Value 1
}
