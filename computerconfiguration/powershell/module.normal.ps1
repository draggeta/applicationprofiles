# Install often used PowerShell modules
$moduleList = @(
    'Az'
    'InvokeBuild'
    'platyPS'
    'Posh-git'
    'PSReadLine'
    'Pester'
)
Install-Module -Name $moduleList -Scope CurrentUser -SkipPublisherCheck -Force
