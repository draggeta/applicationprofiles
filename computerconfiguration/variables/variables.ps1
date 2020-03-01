# Windows Optional Features
$removedOptionalFeatureList = @(
    'SMB1Protocol'
    'MicrosoftWindowsPowerShellV2'
    'MicrosoftWindowsPowerShellV2Root'
)
$enabledOptionalFeatureList = @(
    'Containers'
    'Containers-DisposableClientVM'
    'HypervisorPlatform'
    'Microsoft-Hyper-V-All'
    'Microsoft-Windows-Subsystem-Linux'
    'VirtualMachinePlatform'
    'Windows-Defender-ApplicationGuard'
)

# Windows Capabilities
$removedCapabilityList = @(
    'Media.WindowsMediaPlayer~~~~0.0.12.0'
)
$enabledCapabilityList = @(
    'OpenSSH.Client~~~~0.0.1.0'
    'OpenSSH.Server~~~~0.0.1.0'
)

# Security
$controlledFolderAccessProcesses = @(
    'code.cmd'
    'powershell.exe'
    'pwsh.exe'
)

# Chocolatey
$softwareList = @(
    '7zip'
    'azure-cli'
    'docker-desktop'
    'git'
    'git-credential-manager-for-windows'
    'golang'
    'firacode'
    'firefox'
    'k-litecodecpackfull'
    'keepass'
    'microsoft-edge'
    'microsoft-teams.install'
    'microsoftazurestorageexplorer'
    'mremoteng'
    'notepadplusplus'
    'paint.net'
    'putty'
    'python'
    'terraform'
    'vault'
    'vscode'
    'wireshark'
)

$softwareListInstallArgs = @{
    'powershell-core' = 'ADDEXPLORERCONTEXTMENUOPENPOWERSHELL=1 REGISTERMANIFEST=1 ENABLEPSREMOTING=1'
}

# PowerShell
$psModuleList = @(
    'Az'
    'InvokeBuild'
    'platyPS'
    'Posh-git'
    'PSReadLine'
    'Pester'
)

# VSCode
$vscodeExtensionList = @(
    'eamodio.gitlens'
    'Equinusocio.vsc-material-theme'
    'mauve.terraform'
    'ms-python.python'
    'ms-vscode.Go'
    'ms-vscode.powershell'
    'ms-vscode-remote.vscode-remote-extensionpack'
    'PeterJausovec.vscode-docker'
    'PKief.material-icon-theme'
    'redhat.vscode-yaml'
    'run-at-scale.terraform-doc-snippets'
    'Tyriar.shell-launcher'
    'vscoss.vscode-ansible'
)