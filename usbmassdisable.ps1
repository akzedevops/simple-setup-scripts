# Run PowerShell as Administrator

# Disable USB mass storage by setting registry value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4

# Disable USB mass storage by disabling the driver
Disable-PnpDevice -InstanceId (Get-PnpDevice -FriendlyName "USB Mass Storage Device").InstanceId -Confirm:$false
