#Here is an example of how to passthrough a NICs port a virtual machine with Hyper-V
#https://devblogs.microsoft.com/scripting/passing-through-devices-to-hyper-v-vms-by-using-discrete-device-assignment/

$vmName = 'pfSense'
$device1 = 'Intel(R) PRO/1000 PT Dual Port Server Adapter'
$device2 = 'Intel(R) PRO/1000 PT Dual Port Server Adapter #2'
$vm = Get-VM -Name $vmName

$dev = (Get-PnpDevice -PresentOnly).Where{ $_.FriendlyName -like $device1 }
$dev2 = (Get-PnpDevice -PresentOnly).Where{ $_.FriendlyName -like $device2 }

Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false
Disable-PnpDevice -InstanceId $dev2.InstanceId -Confirm:$false

$locationPath = (Get-PnpDeviceProperty -KeyName DEVPKEY_Device_LocationPaths -InstanceId $dev.InstanceId).Data[0]
$locationPath2 = (Get-PnpDeviceProperty -KeyName DEVPKEY_Device_LocationPaths -InstanceId $dev2.InstanceId).Data[0]

Dismount-VmHostAssignableDevice -LocationPath $locationPath -Force -Verbose
Dismount-VmHostAssignableDevice -LocationPath $locationPath2 -Force -Verbose

Add-VMAssignableDevice -VM $vm -LocationPath $locationPath -Verbose
Add-VMAssignableDevice -VM $vm -LocationPath $locationPath2 -Verbose

#remove
Remove-VMAssignableDevice -VMName 'pfSense' -Verbose
(Get-VMHostAssignableDevice).Where{ $_.InstanceID -like '*VEN_8086&DEV_105E&SUBSYS_115E8086*' } | Mount-VmHostAssignableDevice -Verbose
(Get-PnpDevice -PresentOnly).Where{ $_.InstanceId -like '*VEN_8086&DEV_105E&SUBSYS_115E8086*' } | Enable-PnpDevice -Confirm:$false -Verbose
