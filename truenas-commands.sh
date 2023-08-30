#Temperature summary
./temperature.sh

#Status and clear any errors on pool
zpool status -v
zpool clear Storport

#Clear task history
systemctl restart middlewared

#Smart data status
smartctl -a /dev/sdb
smartctl -a /dev/sdc
smartctl -a /dev/sdd
smartctl -a /dev/sde
smartctl -a /dev/sdf
smartctl -a /dev/sdg
smartctl -a /dev/sdh
smartctl -a /dev/sdi

#Format to prepare for use in TrueNAS (also requires a reboot)
sgdisk -Z /dev/sdj
sgdisk -Z /dev/sdk
sgdisk -Z /dev/sdl
sgdisk -Z /dev/sdm
sgdisk -Z /dev/sdn
sgdisk -Z /dev/sdo
sgdisk -Z /dev/sdp
sgdisk -Z /dev/sdq
