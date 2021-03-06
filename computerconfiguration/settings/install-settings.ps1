Write-Output "###### Settings"

# Load variables
. (Join-Path $PSScriptRoot -ChildPath "settings.ps1")

$subScripts = Get-ChildItem -Path $PSScriptRoot -Filter "*.settings.ps1"

foreach ($script in $subScripts) {
    . $script.FullName
}

# $poshScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "settings\powershell.settings"
# $poshScripts = Get-ChildItem -Path $poshScriptPath -Filter "*.ps1"

# foreach ($script in $poshScripts) {
#     if ($script.Name -like "*.privileged.ps1") {
#         Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File $($script.FullName)" -Wait
#         Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File $($script.FullName)" -Wait
#     } else {
#         Start-Process runas.exe -ArgumentList "/trustlevel:0x20000 `"powershell.exe -NoProfile -ExecutionPolicy Bypass -File $($script.FullName)`"" -Wait
#         Start-Process runas.exe -ArgumentList "/trustlevel:0x20000 `"pwsh.exe -NoProfile -ExecutionPolicy Bypass -File $($script.FullName)`"" -Wait
#     }
# }
