Write-Output "###### Packages"

# Load variables
. (Join-Path $PSScriptRoot -ChildPath "variables\variables.ps1")

# FEATURES
# Remove unneeded/unsecure Windows features
Write-Output "Removing Optional Features"
Disable-WindowsOptionalFeature -Online -FeatureName $removedOptionalFeatureList -NoRestart > $null

Write-Output "Installing Optional Features"
Enable-WindowsOptionalFeature -Online -FeatureName $enabledOptionalFeatureList -NoRestart > $null

Write-Output "Removing Capabilities"
foreach($capability in $removedCapabilityList) {
    Remove-WindowsCapability -Online -Name $capability > $null
}
Write-Output "Installing Capabilities"
foreach($capability in $enabledCapabilityList) {
    Add-WindowsCapability -Online -Name $capability > $null
}


# SOFTWARE
# Install Chocolatey
Write-Output "Installing Chocolatey"
$outFile = "$env:USERPROFILE\Downloads\install.ps1"
Invoke-WebRequest -Uri https://chocolatey.org/install.ps1 -OutFile $outFile -UseBasicParsing
$sig = Get-AuthenticodeSignature -FilePath $outFile

if ($sig.Status -eq 'Valid' -and $sig.SignerCertificate.Subject -like "*O=`"Chocolatey Software, Inc.`"*") {
    . $outFile > $null
}

Write-Output "Installing software"
choco install -y $softwareList > $null

foreach ($item in $softwareListInstallArgs.GetEnumerator()) {
    choco install -y $item.Key --install-arguments="$($item.Value)" > $null
}
