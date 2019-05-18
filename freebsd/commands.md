

# FreeBSD

# NET


```shell
# creates a tap brige it with the em0 interface

ifconfig tap0 create
sysctl net.link.tap.up_on_open=1
ifconfig bridge0 create
ifconfig bridge0 addm em0 addm tap0
ifconfig bridge0 up
```



## ZFS

 create

```shell
zfs create -V16G -o volmode=dev zroot/zfsdisk0
```



## bhyve



```shell

# run a freebsd installer

sh /usr/share/examples/bhyve/vmrun.sh -c 1 -m 1024M -t tap0 -d guest.img -i -I FreeBSD-10.3-RELEASE-amd64-bootonly.iso guestname

bhyve -A -H -P -s 0:0,hostbridge -s 1:0,lpc -s 2:0,virtio-net,tap0 -s3:0,virtio-blk,/dev/zvol/zroot/linuxdisk0 \
    -l com1,stdio -c 4 -m 1024M linuxguest


bhyve -A -H -P -s 0:0,hostbridge -s 1:0,lpc 		\
	-s 2:0,virtio-net,tap0				\
	-s 3:0,virtio-blk,/dev/zvol/data_disk/pfsense	\
	-s 4:0,ahci-cd,installer.iso \
	-l com1,stdio -c 2 -m 4096M pfsense 



# install
sh /usr/share/examples/bhyve/vmrun.sh -c 1 -m 4096M \
	-t tap0 \
	-t tap1	\
	-d /dev/zvol/data_disk/pfsense \
	-i -I installer.iso \
	pfsense

# start
sh /usr/share/examples/bhyve/vmrun.sh -c 1 -m 4096M \
	-t tap0 \
	-t tap1 \
        -d /dev/zvol/data_disk/pfsense \
	-C /dev/nmdm0A	\
        pfsense &


cu -l /dev/nmdm0B



# destroy vm
bhyvectl --destroy --vm=guestname


```


