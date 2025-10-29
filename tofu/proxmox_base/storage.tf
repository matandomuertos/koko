## I didn't find the way to do it in tf

## KOKO-PVE1
# pvesm add dir iso --path /iso --content iso,import --nodes koko-pve1 --shared 0
# pvesm add dir data --path /data --content images,rootdir --is_mountpoint 1 --nodes koko-pve1 --shared 0
# pvesm add dir data-hdd --path /data-hdd --content images,rootdir,backup --is_mountpoint 1 --nodes koko-pve1 --shared 0

## KOKO-PVE2
# pvesm add dir iso2 --path /iso --content iso,import --nodes koko-pve2 --shared 0
# pvesm add dir data2 --path /data --content images,rootdir --is_mountpoint 1 --nodes koko-pve2 --shared 0
# pvesm add dir data-hdd2 --path /data-hdd --content images,rootdir,backup --is_mountpoint 1 --nodes koko-pve2 --shared 0
