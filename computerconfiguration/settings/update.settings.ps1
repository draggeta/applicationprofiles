Write-Output "### Windows Updates"

# Windows Update UI settings
Write-Output "Enable restart notification"

$updateSettings = @{
    RestartNotificationsAllowed2 = 1     # Enable update notification
}
$updateRegistryKeyPath = "HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings"
foreach ($item in $updateSettings.GetEnumerator()) {
    Set-ItemProperty -Path $updateRegistryKeyPath -Name $item.Key -Value $item.Value
}
