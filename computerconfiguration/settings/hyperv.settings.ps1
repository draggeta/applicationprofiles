Write-Output "### Hyper-V"

# Add user account to Hyper-V administrators
Write-Output "Adding current user to Hyper-V Administrators"
$members = Get-LocalGroupMember -Group "Hyper-V Administrators"
if ("$env:userdomain\$env:username" -notin $members.Name) {
    Add-LocalGroupMember -Group "Hyper-V Administrators" -Member $env:username
}

# Set default Hyper-V VM folder
Set-VMHost -VirtualMachinePath "$env:SYSTEMDRIVE\Hyper-V" `
    -VirtualHardDiskPath "$env:SYSTEMDRIVE\Hyper-V\Virtual Hard Disks"
