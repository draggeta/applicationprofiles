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
Install-Module -Name $moduleList -Scope CurrentUser -SkipPublisherCheck -Force
