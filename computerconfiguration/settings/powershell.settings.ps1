# Trust the PowerShell Gallery
Write-Output "Setting PowerShell Gallery as trusted"
$policy = Get-PSRepository -Name "PSGallery" | Select-Object -ExpandProperty "InstallationPolicy"
if ($policy -ne "Trusted") {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

# Install often used PowerShell modules
Write-Output "Installing PowerShell modules"

foreach ($module in $psModuleList) {
    Install-Module @module -Force
}
