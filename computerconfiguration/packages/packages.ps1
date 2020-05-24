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
    # 'Windows-Defender-ApplicationGuard'
)

# Windows Capabilities
$removedCapabilityList = @(
    'Media.WindowsMediaPlayer~~~~0.0.12.0'
)
$enabledCapabilityList = @(
    'OpenSSH.Client~~~~0.0.1.0'
    'OpenSSH.Server~~~~0.0.1.0'
)


# Chocolatey
$softwareList = @(
    '7zip'
    'azure-cli'
    'cascadiafonts'
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
    'powertoys'
    'putty'
    'python'
    'signal'
    'terraform'
    'vault'
    'vscode'
    'wireshark'
)

$softwareListInstallArgs = @{
    'powershell-core' = 'ADDEXPLORERCONTEXTMENUOPENPOWERSHELL=1 REGISTERMANIFEST=1 ENABLEPSREMOTING=1'
}
