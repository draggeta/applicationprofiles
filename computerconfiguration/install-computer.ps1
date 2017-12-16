Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Trust the PowerShell Gallery
$policy = Get-PSRepository -Name "PSGallery" | Select-Object -ExpandProperty "InstallationPolicy"
if ($policy -ne "Trusted") {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

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
)
Disable-WindowsOptionalFeature -Online -FeatureName $removedOptionalFeatureList-NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName $enabledOptionalFeatureList -NoRestart

# Create AppModelUnlock if it doesn't exist, required for enabling Developer Mode
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (-not(Test-Path -Path $RegistryKeyPath)) {
    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}

# Add registry value to enable Developer Mode
New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install software
$softwareList = @(
    'git'
    'docker-for-windows'
    'terraform'
    'visualstudiocode'
    'notepadplusplus'
    'googlechrome'
    'firefox'
    'keepass'
    '7zip'
    'golang'
    'microsoft-teams'
    'putty'
    'python'
    'python2'
    'wireshark'
    'vmwarevsphereclient'
    'rdcman'
    'k-litecodecpackfull'
)
choco install -y openssh -params "/SSHAgentFeature /SSHServerFeature"
choco install -y $softwareList

# Install often used PowerShell modules
$moduleList = @(
    'AzureRM'
    'AzureAdPreview'
    'Posh-git'
    'PSReadLine'
    'Pester'
)
Install-Module -Name $moduleList -SkipPublisherCheck -Force
