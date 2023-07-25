# Run PowerShell as Administrator

# Re-enable USB mass storage by setting registry value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 3

# Re-enable USB mass storage by enabling the driver
Enable-PnpDevice -InstanceId (Get-PnpDevice -FriendlyName "USB Mass Storage Device").InstanceId -Confirm:$false
