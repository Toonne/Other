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

#Below example is passing through ASUS USB-C PCI controller card to a virtual machine running Home Assistant
#Useful with for example an Aeotec Z-Stick Gen5 
$vmName = 'HOMIE'
$device1 = 'ASMedia USB 3.1 eXtensible Host Controller - 1.10 (Microsoft)'
$vm = Get-VM -Name $vmName

$dev = (Get-PnpDevice -PresentOnly).Where{ $_.FriendlyName -like $device1 }
Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false
$locationPath = (Get-PnpDeviceProperty -KeyName DEVPKEY_Device_LocationPaths -InstanceId $dev.InstanceId).Data[0]
Dismount-VmHostAssignableDevice -LocationPath $locationPath -Force -Verbose
Add-VMAssignableDevice -VM $vm -LocationPath $locationPath -Verbose

#remove
Remove-VMAssignableDevice -VMName 'HOMIE' -Verbose

(Get-VMHostAssignableDevice).Where{ $_.InstanceID -like '*VEN_1B21&DEV_1242&SUBSYS_86961043*' } | Mount-VmHostAssignableDevice -Verbose
(Get-PnpDevice -PresentOnly).Where{ $_.InstanceId -like '*VEN_1B21&DEV_1242&SUBSYS_86961043*' } | Enable-PnpDevice -Confirm:$false -Verbose

#9305-24i
(Get-VMHostAssignableDevice).Where{ $_.InstanceID -like '*VEN_1000&DEV_00C4&SUBSYS_31A01000*' } | Mount-VmHostAssignableDevice -Verbose
(Get-PnpDevice -PresentOnly).Where{ $_.InstanceId -like '*VEN_1000&DEV_00C4&SUBSYS_31A01000*' } | Enable-PnpDevice -Confirm:$false -Verbose

#Below example is passing through a 9300-8i PCI controller card to a virtual machine running TrueNAS SCALE
$vmName = 'TrueNAS SCALE'
$device1 = 'Avago Adapter, SAS3 3008 Fury -StorPort'
$vm = Get-VM -Name $vmName

Stop-Service "LSAService" #Will lock and prevent Disable-PnpDevice from running

$dev = (Get-PnpDevice -PresentOnly).Where{ $_.FriendlyName -like $device1 }
Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false
$locationPath = (Get-PnpDeviceProperty -KeyName DEVPKEY_Device_LocationPaths -InstanceId $dev.InstanceId).Data[0]
Dismount-VmHostAssignableDevice -LocationPath $locationPath -Force -Verbose
Add-VMAssignableDevice -VM $vm -LocationPath $locationPath -Verbose

#remove
Remove-VMAssignableDevice -VMName 'TrueNAS SCALE' -Verbose
(Get-VMHostAssignableDevice).Where{ $_.InstanceID -like '*VEN_1000&DEV_0097&SUBSYS_30E01000*' } | Mount-VmHostAssignableDevice -Verbose
(Get-PnpDevice -PresentOnly).Where{ $_.InstanceId -like '*VEN_1000&DEV_0097&SUBSYS_30E01000*' } | Enable-PnpDevice -Confirm:$false -Verbose
