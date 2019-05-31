# Install often used Python modules
$requirementsPath = Join-Path -Path $PSScriptRoot -ChildPath "../files/requirements.txt"
python.exe -m pip install --user --upgrade -r $requirementsPath
