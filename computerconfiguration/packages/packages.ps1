# Windows Optional Features
$removedOptionalFeatureList = @(
    'Internet-Explorer-Optional-amd64'
    'MicrosoftWindowsPowerShellV2'
    'MicrosoftWindowsPowerShellV2Root'
    'Printing-Foundation-Features'
    'Printing-XPSServices-Features'
    'SMB1Protocol'
    'WorkFolders-Client'
)
$enabledOptionalFeatureList = @(
    'Containers'
    'Containers-DisposableClientVM'
    'HypervisorPlatform'
    'Microsoft-Hyper-V-All'
    'Microsoft-Windows-Subsystem-Linux'
    'TelnetClient'
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

# Chocolatey
$softwareList = @(
    '7zip'
    'azure-cli'
    'azure-functions-core-tools-3'
    'cascadiafonts'
    'docker-desktop'
    'drawio'
    'git'
    'git-credential-manager-for-windows'
    'golang'
    'hugo'
    'firefox'
    'k-litecodecpackfull'
    'keepass'
    'microsoft-edge'
    'microsoft-teams'
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
    'wsl2'
)

$softwareListInstallArgs = @{
    'powershell-core' = 'ADDEXPLORERCONTEXTMENUOPENPOWERSHELL=1 REGISTERMANIFEST=1 ENABLEPSREMOTING=1'
}
