Write-Output "### Python"

# Install often used Python modules
Write-Output "Installing Python modules"
$requirementsPath = Join-Path -Path $PSScriptRoot -ChildPath "../../python/requirements.txt" -Resolve
python.exe -m pip install --user --upgrade -r $requirementsPath > $null
