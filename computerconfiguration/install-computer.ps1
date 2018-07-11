Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Set time configuration
w32tm /config /update /manualpeerlist:nl.pool.ntp.org
Restart-Service w32time
w32tm /resync /nowait

# Remove unneeded/unsecure Windows features
$removedOptionalFeatureList = @(
    'SMB1Protocol'
    'MicrosoftWindowsPowerShellV2'
    'MicrosoftWindowsPowerShellV2Root'
    'WindowsMediaPlayer'
)
$enabledOptionalFeatureList = @(
    'Microsoft-Hyper-V-All'
    'Containers'
    'Microsoft-Windows-Subsystem-Linux'
    'Windows-Defender-ApplicationGuard'
)
Disable-WindowsOptionalFeature -Online -FeatureName $removedOptionalFeatureList -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName $enabledOptionalFeatureList -NoRestart

# Workaround for Docker for Windows slow network connectivity issues. By disabling RSC, packets aren't dropped anymore
# See: https://github.com/docker/for-win/issues/698#issuecomment-314902326
Get-NetAdapterRsc | Disable-NetAdapterRsc

# Create AppModelUnlock if it doesn't exist, required for enabling Developer Mode
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (-not(Test-Path -Path $RegistryKeyPath)) {
    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}

# Add registry value to enable Developer Mode
New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1

# Set Explorer settings
$explorerSettings = @{
    Hidden          = 1     # Show hidden items
    HideFileExt     = 0     # Show file extensions
    SeparateProcess = 1     # Open Explorer windows in separate process
}
$explorerRegistryKeyPath = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
foreach ($item in $explorerSettings.GetEnumerator()) {
    Set-ItemProperty -Path $explorerRegistryKeyPath -Name $item.Key -Value $item.Value
}

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install software
$softwareList = @(
    'git'
    'docker-for-windows'
    'openssl.light'
    'golang'
    'python'
    'python2'
    'firefox'
    'googlechrome'
    '7zip'
    'k-litecodecpackfull'
    'keepass'
    'microsoft-teams'
    'microsoftazurestorageexplorer'
    'notepadplusplus'
    'paint.net'
    'putty'
    'rdcman'
    'visualstudiocode'
    'wireshark'
    'terraform'
    'vagrant'
    'vault'
)
#choco install -y openssh -params "/SSHAgentFeature /SSHServerFeature"
choco install -y $softwareList

# Trust the PowerShell Gallery
$policy = Get-PSRepository -Name "PSGallery" | Select-Object -ExpandProperty "InstallationPolicy"
if ($policy -ne "Trusted") {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

# Install often used PowerShell modules
$moduleList = @(
    'AzureRM'
    'AzureAdPreview'
    'InvokeBuild'
    'platyPS'
    'Posh-git'
    'PSReadLine'
    'Pester'
)
Install-Module -Name $moduleList -SkipPublisherCheck -Force

# Enable Controlled folder access
Set-MpPreference -EnableControlledFolderAccess Enabled
