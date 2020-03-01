Write-Output "### VSCode"

# Install vscode extensions
Write-Output "Installing VSCode extensions"
foreach ($extension in $vscodeExtensionList) {
    code.cmd --install-extension $extension > $null
}
