# Security
$controlledFolderAccessProcesses = @(
    'code.cmd'
    'explorer.exe'
    'powershell.exe'
    'pwsh.exe'
)

# Dotfiles
$dotfileList = @(
    @{
        description = "KeePass"
        link        = "${env:ProgramFiles}\KeePass Password Safe 2\KeePass.config.enforced.xml"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../keepass/KeePass.config.enforced.xml" -Resolve)
    },
    @{
        description = "GitConfig"
        link        = "${env:USERPROFILE}\.gitconfig"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../git/.gitconfig" -Resolve)
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
        link        = "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../windowsterminal/settings.json" -Resolve)
    }
    @{
        description = "PowerShell"
        link        = "$([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments))\PowerShell\Microsoft.PowerShell_profile.ps1"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../powershell/profile.ps1" -Resolve)
    }
    @{
        description = "Oh-My-Posh"
        link        = "${env:USERPROFILE}\.oh-my-posh.omp.json"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../powershell/.oh-my-posh.omp.json" -Resolve)
    }
    @{
        description = "WindowsPowerShell"
        link        = "$([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments))\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../powershell/profile.ps1" -Resolve)
    }
)

# PowerShell
$psModuleList = @(
    @{
        Name  = "InvokeBuild"
        Scope = "CurrentUser"
    },
    @{
        Name  = "oh-my-posh"
        Scope = "CurrentUser"
    },
    @{
        Name  = "Terminal-Icons"
        Scope = "CurrentUser"
    },
    @{
        Name               = "Pester"
        Scope              = "CurrentUser"
        SkipPublisherCheck = $true
    },
    @{
        Name  = "platyPS"
        Scope = "CurrentUser"
    },
    @{
        Name  = "posh-git"
        Scope = "CurrentUser"
    },
    @{
        Name  = "Az"
        Scope = "CurrentUser"
    },
    @{
        Name  = "AWS.Tools.Common"
        Scope = "CurrentUser"
    },
    @{
        Name  = "AWS.Tools.Installer"
        Scope = "CurrentUser"
    }
)

# VSCode
$vscodeExtensionList = @(
    'eamodio.gitlens'
    'Equinusocio.vsc-material-theme'
    'mauve.terraform'
    'ms-python.python'
    'ms-azuretools.vscode-docker'
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
