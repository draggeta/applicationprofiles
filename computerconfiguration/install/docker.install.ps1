# Workaround for Docker for Windows slow network connectivity issues. By disabling RSC, packets aren't dropped anymore
# See: https://github.com/docker/for-win/issues/698#issuecomment-314902326
Get-NetAdapterRsc | Disable-NetAdapterRsc

# Workaround for Docker not being able to start when drive encryption is blocking writes
# See: https://github.com/docker/for-win/issues/1297
$bitLockerRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE"
Set-ItemProperty -Path $bitLockerRegistryKeyPath -Name "FDVDenyWriteAccess" -Value 0

# Set docker to Windows mode instead of linux
& "$env:ProgramFiles\Docker\Docker\DockerCli.exe" -SwitchWindowsEngine

# Enable experimental mode
$daemonPath = Join-Path -Path $env:ProgramData -ChildPath "Docker\config\daemon.json"
$daemon = @"
{
    "registry-mirrors": [],
    "insecure-registries": [],
    "debug": true,
    "experimental": true
}
"@
Set-Content -Path $daemonPath -Value $daemon
