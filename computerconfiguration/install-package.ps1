Set-ExecutionPolicy -ExecutionPolicy RemoteSigned


# SYSTEM
# Set time configuration
w32tm /config /update /manualpeerlist:nl.pool.ntp.org
Restart-Service w32time
w32tm /resync /nowait


# FEATURES
# Remove unneeded/unsecure Windows features
$removedOptionalFeatureList = @(
    'SMB1Protocol'
    'MicrosoftWindowsPowerShellV2'
    'MicrosoftWindowsPowerShellV2Root'
    'WindowsMediaPlayer'
)
$enabledOptionalFeatureList = @(
    'Containers'
    'Containers-DisposableClientVM'
    'HypervisorPlatform'
    'Microsoft-Hyper-V-All'
    'Microsoft-Windows-Subsystem-Linux'
    'VirtualMachinePlatform'
    'Windows-Defender-ApplicationGuard'
)
Disable-WindowsOptionalFeature -Online -FeatureName $removedOptionalFeatureList -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName $enabledOptionalFeatureList -NoRestart
$removedCapabilityList = @(
    'Media.WindowsMediaPlayer~~~~0.0.12.0'
)
$enabledCapabilityList = @(
    'OpenSSH.Client~~~~0.0.1.0'
    'OpenSSH.Server~~~~0.0.1.0'
)
foreach($capability in $removedCapabilityList) {
    Remove-WindowsCapability -Online -Name $capability
}
foreach($capability in $enabledCapabilityList) {
    Add-WindowsCapability -Online -Name $capability
}


## Create AppModelUnlock if it doesn't exist, required for enabling Developer Mode
#$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
#if (-not(Test-Path -Path $RegistryKeyPath)) {
#    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
#}

## Add registry value to enable Developer Mode
#New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1


# SOFTWARE
# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Install software
$softwareList = @(
    '7zip'
    'azure-cli'
    'docker-desktop'
    'git'
    'git-credential-manager-for-windows'
    'golang'
    'firacode'
    'firefox'
    # 'googlechrome'
    'jabra-direct'
    'k-litecodecpackfull'
    'keepass'
    'microsoft-teams'
    'microsoftazurestorageexplorer'
    'mremoteng'
    'notepadplusplus'
    'paint.net'
    'putty'
    'python'
    'terraform'
    'vault'
    'vscode'
    'wireshark'
)
choco install -y $softwareList
$softwareInstallArgs = @{
    'powershell-core' = 'ADDEXPLORERCONTEXTMENUOPENPOWERSHELL=1 REGISTERMANIFEST=1 ENABLEPSREMOTING=1'
}
foreach ($item in $softwareInstallArgs.GetEnumerator()) {
    choco install -y $item.Key --install-arguments="$($item.Value)"
}


# WINDOWS DEFENDER
# Enable Controlled folder access
Set-MpPreference -EnableControlledFolderAccess Enabled
# Enable tamper protection (cannot do it via module yet)
$mpRegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
Set-ItemProperty -Path $mpRegistryKeyPath -Name "TamperProtection" -Value 5


# Add user account to Hyper-V administrators
Add-LocalGroupMember -Group "Hyper-V Administrators" -Member $env:username

Restart-Computer -Force
