Write-Output "### SSH"

# Enable SSH agent
Write-Output "Enabling the SSH agent service"
$service = Get-Service -Name ssh-agent

if ($service.StartupType -eq 'Disabled') {
    Set-Service -Name ssh-agent -StartupType Automatic
    start-service -Name ssh-agent
}
