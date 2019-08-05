
# Enabling vsock support


```shell

# check iommu in kernel, adding intel_iommu=on in kernel command line
grep intel_iommu /boot/grub/grub.cfg


# check vhost_vsock kernel module 
[ ! -f /dev/vhost-vsock ] && modprobe vhost_vsock
[ -f /dev/vhost-vsock ] && chmod 0666 /dev/vhost-vsock 
[ -f /dev/vsock ] && chmod a+r /dev/vsock 
# check devices
ls -l /dev/vhost*

# add "/dev/vhost-vsock" to the cgroup_device_acl into /etc/libvirt/qemu.conf and restart libvirtd
systemctl restart libvirtd.service

```

Add the **custom qemu** args to the vm domain

```xml

<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <name>guest</name>
  <qemu:commandline>
    <qemu:arg value='-device'/>
    <qemu:arg value='vhost-vsock-pci,id=vhost-vsock-pci0,guest-cid=3'/>
  </qemu:commandline>

```

It seems libvirt can handle the vsock declaration 

```xml
<vsock model='virtio'>
<cid auto='no' address='3'/>
<alias name='ua-04c3388d-4e33-4023-84de-a2205c777asdfdsf'/>
<address type='pci' domain='0x0000' bus='0x00' slot='0x0b' function='0x0'/>
</vsock>

```

# guest to host ssh


```shell

# on host
nc-vsock -l 2222 -t 127.0.0.1 22


# on guest
nc-vsock -s 2222 -c 3 2222 &

ssh -p 2222 user@127.0.0.1

```

# References

https://github.com/stefanha/nc-vsock
https://github.com/lotib/nc-vsock
https://github.com/clownix/cloonix_vsock
https://bugzilla.redhat.com/show_bug.cgi?id=1291851
https://medium.com/@mdlayher/linux-vm-sockets-in-go-ea11768e9e67


