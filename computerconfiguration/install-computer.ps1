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


# EXPLORER
# Set Explorer settings
$explorerSettings = @{
    Hidden          = 1     # Show hidden items
    HideFileExt     = 0     # Show file extensions
    SeparateProcess = 1     # Open Explorer windows in separate process
}
$explorerRegistryKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
foreach ($item in $explorerSettings.GetEnumerator()) {
    Set-ItemProperty -Path $explorerRegistryKeyPath -Name $item.Key -Value $item.Value
}
$personalizeSettings = @{
    AppsUseLightTheme    = 0     # Set theme to dark
    SystemUsesLightTheme = 0     # Set theme to dark
}
$personalizeRegistryKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
foreach ($item in $personalizeSettings.GetEnumerator()) {
    Set-ItemProperty -Path $personalizeRegistryKeyPath -Name $item.Key -Value $item.Value
}


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


# MODULES/PACKAGES
# Trust the PowerShell Gallery
$policy = Get-PSRepository -Name "PSGallery" | Select-Object -ExpandProperty "InstallationPolicy"
if ($policy -ne "Trusted") {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
}
# Install often used PowerShell modules
$moduleList = @(
    'Az'
    'InvokeBuild'
    'platyPS'
    'Posh-git'
    'PSReadLine'
    'Pester'
)
Install-Module -Name $moduleList -SkipPublisherCheck -Force
# Install often used Python modules
python.exe -m pip install --upgrade -r requirements.txt


# DOCKER
# Workaround for Docker for Windows slow network connectivity issues. By disabling RSC, packets aren't dropped anymore
# See: https://github.com/docker/for-win/issues/698#issuecomment-314902326
Get-NetAdapterRsc | Disable-NetAdapterRsc

# Workaround for Docker not being able to start when drive encryption is blocking writes
# See: https://github.com/docker/for-win/issues/1297
$bitLockerRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE"
Set-ItemProperty -Path $bitLockerRegistryKeyPath -Name "FDVDenyWriteAccess" -Value 0


# WINDOWS DEFENDER
# Enable Controlled folder access
Set-MpPreference -EnableControlledFolderAccess Enabled
# Enable tamper protection (cannot do it via module yet)
$mpRegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
Set-ItemProperty -Path $mpRegistryKeyPath -Name "TamperProtection" -Value 5
