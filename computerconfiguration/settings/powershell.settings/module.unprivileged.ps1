# Install often used PowerShell modules
Write-Output "Installing PowerShell modules"
Install-Module -Name $psModuleList -Scope CurrentUser -SkipPublisherCheck -Force
