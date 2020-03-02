Write-Output "### Dotfiles"

Write-Output "Linking 'dotfiles'"

$dotfileList = @(
    @{
        description = "KeePass"
        link        = "$env:appdata\KeePass\KeePass.config.xml"
        target      = (Join-Path -Path $PSScriptRoot -ChildPath "../../keepass/KeePass.config.xml" -Resolve)
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
)

foreach ($file in $dotfileList) {
    if ((Test-Path $file.link) -and ($file.target -ne (Get-Item $file.link).target)) {
        Remove-Item $file.link
        New-Item -Path $file.link -ItemType SymbolicLink -Value $file.target
    }
    if (-not (Test-Path $file.link)) {
        New-Item -Path $file.link -ItemType SymbolicLink -Value $file.target
    }
}
