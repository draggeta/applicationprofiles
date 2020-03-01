Write-Output "### Time"

# Set time configuration
Write-Output "Configuring NTP server"
w32tm /config /update /manualpeerlist:nl.pool.ntp.org > $null
Restart-Service w32time
w32tm /resync /nowait > $null

Write-Output "Enabling Automatic Timezone Detection"
$tzRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate"
if (-not (Test-Path $tzRegistryKeyPath)) {
    New-Item -Path $tzRegistryKeyPath -Name "Start" -Value 3 -Force
}
else {
    Set-ItemProperty -Path $tzRegistryKeyPath -Name "Start" -Value 3
}