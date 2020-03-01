Write-Output "### WSL"

Write-Output "Setting WSL2 as the default"
# Set WSL2 as the default
wsl.exe --set-default-version 2 > $null
