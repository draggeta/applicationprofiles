. (Join-Path -Path $PSScriptRoot -ChildPath "../../variables/variables.ps1" -Resolve)

# Install often used PowerShell modules
Write-Output "Installing PowerShell modules"

foreach ($module in $psModuleList) {
    Install-Module @module -Force
}
