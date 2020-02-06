

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

zfs list -t snapshot

# copy and leave
nohup sh -c "zfs send pool/dataset@snapshot | zfs receive -F pool/dataset"

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

## vm-bhyve

```shell

# pfSense installation example
# https://shaner.life/bhyve-pfsense-2-4-no-console-menu/

pkg install -y vm-bhyve grub2-bhyve
zfs create -o mountpoint=/mnt/bhyve zroot/bhyve
sysrc vm_enable="YES"
sysrc vm_dir="zfs:zroot/bhyve"
vm init

vm switch import wan bridge1
vm switch import lan bridge0
fetch -o /tmp/pf-memstick-serial.img.gz 
https://nyifiles.pfsense.org/mirror/downloads/pfSense-CE-memstick-serial-2.4.2-RELEASE-amd64.img.gz
gunzip /tmp/pf-memstick-serial.img.gz


# pfsense vm

cd /bhyve/.templates
cat > pfsense.conf <<EOF
loader="bhyveload"
cpu=2
memory=512M
network0_type="virtio-net"
network0_switch="wan"
network1_type="virtio-net"
network1_switch="mgmt"
disk0_type="virtio-blk"
disk0_name="disk0.img"
EOF
vm create -t pfsense -s10G pfsense1

# add installer
cd /bhyve/pfsense1/
mkdir tmp
cp /tmp/installer.img tmp/
cp pfsense1.conf pfsense1.orig.conf
cat >pfsense1.conf<<EOF
loader="bhyveload"
cpu=2
memory=512M
network0_type="virtio-net"
network0_switch="wan"
network1_type="virtio-net"
network1_switch="mgmt"
disk0_type="virtio-blk"
disk0_name="/tmp/installer.img"
disk1_type="virtio-blk"
disk1_name="disk0.img"
EOF
vm start pfsense1
vm console pfsense1


# revert installer disk configuration and restart
vm stop pfsense1
mv /bhyve/pfsense1/pfsense1.orig.conf /bhyve/pfsense1/psensef1.conf
vm start pfsense1


# on freenas don't forget to write your rc.conf
mount -uw /
cp /etc/rc.conf /conf/base/etc/rc.conf

# or append it to your rc.conf
vm_enable="YES"
vm_dir="zfs:data_disk/bhyve"
vm_list="pfsense1"
vm_delay="5"

```


# freenas

to modify rc.conf ...

```shell
mount -uw / 
#edit /conf/base/etc/rc.conf or /conf/base/*
mount -ur / 
```

Or do the freenas way using tunable in gui.
