# Install vscode extensions

$extensionList = @(
    'eamodio.gitlens'
    'Equinusocio.vsc-material-theme'
    'mauve.terraform'
    'ms-python.python'
    'ms-vscode.Go'
    'ms-vscode.powershell'
    'PeterJausovec.vscode-docker'
    'PKief.material-icon-theme'
    'redhat.vscode-yaml'
    'run-at-scale.terraform-doc-snippets'
    'Tyriar.shell-launcher'
    'vscoss.vscode-ansible'
)
foreach ($extension in $extensionList) {
    code.cmd --install-extension $extension
}
