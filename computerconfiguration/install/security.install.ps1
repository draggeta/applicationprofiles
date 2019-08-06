# WINDOWS SECURITY

# Enable Controlled folder access
Set-MpPreference -EnableControlledFolderAccess Enabled
# Enable tamper protection (cannot do it via module yet)
$mpRegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
Set-ItemProperty -Path $mpRegistryKeyPath -Name "TamperProtection" -Value 5


# Virtualization based security (Core Isolation/Memory Integrity)
$vbsRegistryKeyPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios"
Set-ItemProperty -Path $vbsRegistryKeyPath -Name "HypervisorEnforcedCodeIntegrity" -Value 1
