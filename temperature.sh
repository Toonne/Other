#!/bin/sh

#TrueNAS temperature script

### Parameters ###
cores=4
drives="sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm sdn sdo sdp sdq"
drives_serial=""

### CPU ###
echo ""
cores=$((cores - 1))
for core in $(seq 0 $cores)
do
    temp="$(sysctl -a | grep "cpu.${core}.temp" | cut -c24-25 | tr -d "\n")"
    printf "CPU %s: %s C\n" "$core" "$temp"
done

### Disks ###
echo ""
for drive in $drives
do
    serial="$(smartctl -i /dev/${drive} | grep "Serial Number" | awk '{print $3}')"
    model="$(smartctl -i /dev/${drive} | grep "Device Model" | awk '{print $4}')"
    temp="$(smartctl -A /dev/${drive} | grep "Temperature_Celsius" | awk '{print $10}')"
    power_on_hours="$(smartctl -A /dev/${drive} | grep "Power_On_Hours" | awk '{print $10}')"
    printf "%s %-15s: Temperature: %s C, Power on Hours: %6s (%s)\n" "$drive" "$serial" "$temp" "$power_on_hours" "$model"
done
echo ""

### Disks ###
echo ""
for drive in $drives_serial
do
    serial="$(smartctl -i /dev/disk/by-id/ata-WDC_*_${drive} | grep "Serial Number" | awk '{print $3}')"
    model="$(smartctl -i /dev/disk/by-id/ata-WDC_*_${drive} | grep "Device Model" | awk {'printf ("%s %s", $3, $4)'})"
    temp="$(smartctl -A /dev/disk/by-id/ata-WDC_*_${drive} | grep "Temperature_Celsius" | awk '{print $10}')"
    power_on_hours="$(smartctl -A /dev/disk/by-id/ata-WDC_*_${drive} | grep "Power_On_Hours" | awk '{print $10}')"
    printf "Serial: %s, Temperature: %s°C, Power on Hours: %6s, Model: %s\n" "$serial" "$temp" "$power_on_hours" "$model"
done
echo ""
