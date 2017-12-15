# Trust the PowerShell Gallery
$policy = Get-PSRepository -Name "PSGallery" | Select-Object -ExpandProperty "InstallationPolicy"
if ($policy -ne "Trusted") {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Remove unneeded/unsecure Windows features
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol, MicrosoftWindowsPowerShellV2, MicrosoftWindowsPowerShellV2Root, WindowsMediaPlayer -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All, Containers, Microsoft-Windows-Subsystem-Linux -NoRestart

# Install software
choco install -y openssh -params "/SSHAgentFeature /SSHServerFeature"
choco install -y git, terraform, visualstudiocode, notepadplusplus, googlechrome, firefox, keepass, 7zip, golang, microsoft-teams, putty.install, python, python2, wireshark, vmwarevsphereclient, rdcman

# Install often used PowerShell modules
Install-Module -Name AzureRM, AzureAdPreview, Posh-git, PSReadLine, Pester -SkipPublisherCheck -Force