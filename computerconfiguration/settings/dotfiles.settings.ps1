Write-Output "### Dotfiles"

Write-Output "Linking 'dotfiles'"
foreach ($file in $dotfileList) {
    $file.description
    if ((Test-Path $file.link) -and ($file.target -ne (Get-Item $file.link).target)) {
        Remove-Item $file.link
        New-Item -Path $file.link -ItemType SymbolicLink -Value $file.target
    }
    if (-not (Test-Path $file.link)) {
        New-Item -Path $file.link -ItemType SymbolicLink -Value $file.target -Force
    }
}
