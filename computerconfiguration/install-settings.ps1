$subScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "install"
$subScripts = Get-ChildItem -Path $subScriptPath -Filter "*.ps1"

foreach ($script in $subScripts) {
    . $script.FullName
}
