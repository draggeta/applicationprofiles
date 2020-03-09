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

# Security
$controlledFolderAccessProcesses = @(
    'code.cmd'
    'powershell.exe'
    'pwsh.exe'
)

# Dotfiles
$dotfileList = @(
    @{
        description = "KeePass"
        link        = "${env:ProgramFiles(x86)}\KeePass Password Safe 2\KeePass.config.enforced.xml"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../keepass/KeePass.config.enforced.xml" -Resolve)
    },
    @{
        description = "VSCode Keybindings"
        link        = "$env:appdata\Code\User\keybindings.json"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../vscode/keybindings.json" -Resolve)
    },
    @{
        description = "VSCode Settings"
        link        = "$env:appdata\Code\User\settings.json"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../vscode/settings.json" -Resolve)
    },
    @{
        description = "Windows Terminal"
        link        = "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../windowsterminal/profiles.json" -Resolve)
    }
    @{
        description = "PowerShell"
        link        = "$([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments))\PowerShell\Microsoft.PowerShell_profile.ps1"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../powershell/profile.ps1" -Resolve)
    }
    @{
        description = "WindowsPowerShell"
        link        = "$([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments))\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../powershell/profile.ps1" -Resolve)
    }
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

# PowerShell
$psModuleList = @(
    'InvokeBuild'
    'Pester'
    'platyPS'
    'oh-my-posh'
    'posh-git'
    'Az'
    'AWS.Tools.Common'
    'AWS.Tools.Installer'
    'PSReadLine'
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
