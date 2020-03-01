$subScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "install"
$subScripts = Get-ChildItem -Path $subScriptPath -Filter "*.ps1"

foreach ($script in $subScripts) {
    . $script.FullName
}

$poshScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "powershell"
$poshScripts = Get-ChildItem -Path $poshScriptPath -Filter "*.ps1"

foreach ($script in $poshScripts) {
    if ($script.Name -like "*.elevated.ps1") {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File $($script.FullName)" -Wait
        Start-Process pwsh.exe -ArgumentList "-ExecutionPolicy Bypass -File $($script.FullName)" -Wait
    }
    else {
        Start-Process runas.exe -ArgumentList "/trustlevel:0x20000 `"powershell.exe -ExecutionPolicy Bypass -File $($script.FullName)`"" -Wait
        Start-Process runas.exe -ArgumentList "/trustlevel:0x20000 `"pwsh.exe -ExecutionPolicy Bypass -File $($script.FullName)`"" -Wait
    }

}