Write-Output "### Docker"

# Workaround for Docker for Windows slow network connectivity issues. By disabling RSC, packets aren't dropped anymore
# See: https://github.com/docker/for-win/issues/698#issuecomment-314902326
Write-Output "Disabling network adapter RSC"
Get-NetAdapterRsc | Disable-NetAdapterRsc

# Workaround for Docker not being able to start when drive encryption is blocking writes
# See: https://github.com/docker/for-win/issues/1297
Write-Output "Disabling BitLocker removable drive encryption enforcement"
$bitLockerRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE"
if (Test-Path $bitLockerRegistryKeyPath) {
    Set-ItemProperty -Path $bitLockerRegistryKeyPath -Name "FDVDenyWriteAccess" -Value 0
}

Write-Output "Switching Docker to Linux in WSL2 mode"
# Set docker to Windows mode instead of linux
& "$env:ProgramFiles\Docker\Docker\DockerCli.exe" -SwitchLinuxEngine

# This isn't needed anymore with WSL2
# Write-Output "Enabling Docker experimental mode"
# # Enable experimental mode
# $daemonPath = Join-Path -Path $env:ProgramData -ChildPath "Docker\config\daemon.json"
# $daemon = @"
# {
#     "registry-mirrors": [],
#     "insecure-registries": [],
#     "debug": true,
#     "experimental": true
# }
# "@
# Set-Content -Path $daemonPath -Value $daemon
