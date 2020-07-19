Write-Output "### Windows Security"

# Enable Controlled folder access
Write-Output "Enabling controlled folder access"
Set-MpPreference -EnableControlledFolderAccess Enabled

Write-Output "Allowing apps through controlled folder access"
foreach ($process in $controlledFolderAccessProcesses) {
    Add-MpPreference -ControlledFolderAccessAllowedApplications (Get-Command -Name $process).Source
}

# Enable blocking of Potentially Unwanted Applications
Write-Output "Enabling blocking of PUAP"
Set-MpPreference -PUAProtection $true

# Enable Block at first sight functionality
Write-Output "Enabling tamper protection"
$mpRegistryKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet"
if (-not (Test-Path $mpRegistryKeyPath)) {
    New-Item -Path $mpRegistryKeyPath -Name "DisableBlockAtFirstSeen" -Value 0 -Force
    New-Item -Path $mpRegistryKeyPath -Name "SpynetReporting" -Value 2 -Force
    New-Item -Path $mpRegistryKeyPath -Name "SubmitSamplesConsent" -Value 3 -Force  # 3 sends all samples
} else {
    Set-ItemProperty -Path $mpRegistryKeyPath -Name "DisableBlockAtFirstSeen" -Value 0
    Set-ItemProperty -Path $mpRegistryKeyPath -Name "SpynetReporting" -Value 2
    Set-ItemProperty -Path $mpRegistryKeyPath -Name "DSubmitSamplesConsent" -Value 3
}

# Set Defender to be more strict about blocking, but allow exceptions
Write-Output "Set Defender to be more strict"
$mpRegistryKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine"
if (-not (Test-Path $mpRegistryKeyPath)) {
    New-Item -Path $mpRegistryKeyPath -Name "DMpBafsExtendedTimeout" -Value 10 -Force
    New-Item -Path $mpRegistryKeyPath -Name "MpCloudBlockLevel" -Value 2 -Force  # 0 = default, 1 = moderate, 2 = high, 4 = high+
} else {
    Set-ItemProperty -Path $mpRegistryKeyPath -Name "DMpBafsExtendedTimeout" -Value 10
    Set-ItemProperty -Path $mpRegistryKeyPath -Name "MpCloudBlockLevel" -Value 2
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
} else {
    Set-ItemProperty -Path $vbsRegistryKeyPath -Name "HypervisorEnforcedCodeIntegrity" -Value 1
}

# Run Defender in a sandbox
Write-Output "Running Defender in a sandbox"
[System.Environment]::SetEnvironmentVariable('MP_FORCE_USE_SANDBOX', 1, [System.EnvironmentVariableTarget]::Machine)

# Disable Autoplay
$autoplayRegistryKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers"
if (-not (Test-Path $autoplayRegistryKeyPath)) {
    New-Item -Path $autoplayRegistryKeyPath -Name "DisableAutoplay" -Value 1 -Force
} else {
    Set-ItemProperty -Path $autoplayRegistryKeyPath -Name "DisableAutoplay" -Value 1
}
