Write-Output "### Personalization"

# Set Explorer settings
Write-Output "Setting File Explorer preferences"
$explorerSettings = @{
    AutoCheckSelect   = 0     # Hide selection box
    Hidden            = 1     # Show hidden items
    HideFileExt       = 0     # Show file extensions
    SeparateProcess   = 1     # Open Explorer windows in separate process
    TaskbarSmallIcons = 1     # Set small taskbar icons
}
$explorerRegistryKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
foreach ($item in $explorerSettings.GetEnumerator()) {
    Set-ItemProperty -Path $explorerRegistryKeyPath -Name $item.Key -Value $item.Value
}
$personalizeSettings = @{
    AppsUseLightTheme    = 0     # Set theme to dark
    SystemUsesLightTheme = 0     # Set theme to dark
}
$personalizeRegistryKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
foreach ($item in $personalizeSettings.GetEnumerator()) {
    Set-ItemProperty -Path $personalizeRegistryKeyPath -Name $item.Key -Value $item.Value
}

# Accent color
Write-Output "Setting Desktop preferences"
$accentColorSettings = @{
    AutoColorization = 0     # Automatically change accent color depending on background
}
$colorRegistryKeyPath = "HKCU:\Control Panel\Desktop"
foreach ($item in $accentColorSettings.GetEnumerator()) {
    Set-ItemProperty -Path $colorRegistryKeyPath -Name $item.Key -Value $item.Value
}

# Desktop Window Manager colors
$dwmColorSettings = @{
    ColorPrevalence = 1     # Show accent color on title bars and window borders
}
$colorRegistryKeyPath = "HKCU:\Software\Microsoft\Windows\DWM"
foreach ($item in $dwmColorSettings.GetEnumerator()) {
    Set-ItemProperty -Path $colorRegistryKeyPath -Name $item.Key -Value $item.Value
}
