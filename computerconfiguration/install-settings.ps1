Write-Output "###### Settings"

# Load variables
. (Join-Path $PSScriptRoot -ChildPath "variables\variables.ps1")

$subScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "settings"
$subScripts = Get-ChildItem -Path $subScriptPath -Filter "*.ps1"

foreach ($script in $subScripts) {
    . $script.FullName
}

$poshScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "settings\powershell.settings"
$poshScripts = Get-ChildItem -Path $poshScriptPath -Filter "*.ps1"

foreach ($script in $poshScripts) {
    if ($script.Name -like "*.privileged.ps1") {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File $($script.FullName)" -Wait
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File $($script.FullName)" -Wait
    } else {
        Start-Process runas.exe -ArgumentList "/trustlevel:0x20000 `"powershell.exe -ExecutionPolicy Bypass -File $($script.FullName)`"" -Wait
        Start-Process runas.exe -ArgumentList "/trustlevel:0x20000 `"pwsh.exe -ExecutionPolicy Bypass -File $($script.FullName)`"" -Wait
    }
}
