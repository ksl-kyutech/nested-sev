#!/bin/sh

QEMU=/usr/local/nsev/bin/qemu-system-x86_64
BIOS=/usr/local/nsev/bios/bios.bin

KERNEL=/usr/local/nsev/images/bzImage
INITRD=/usr/local/nsev/images/initrd.img

UUID="e9e564d2-b0d5-4dfb-ad4b-c67dd03e8226"
DISK=/usr/local/nsev/images/l2-vm.qcow2

# GB unit
MEM_G=2

insmod /usr/local/nsev/images/mem32.ko

$QEMU \
    -enable-kvm \
    -smp 2 -m 8K \
    -machine q35,memory-backend=ram1,use-2m=off,hugepages=$MEM_G,mem32-count=64,smm=off,hpet=off \
    -object memory-backend-file,id=ram1,size=8K,share=true,mem-path=/dev/snp-mem \
    -cpu host,host-cache-info=on \
    -bios $BIOS \
    -kernel $KERNEL \
    -initrd $INITRD \
    -append "nopv earlyprintk=serial console=ttyS0 ignore_loglevel no5lvl sev_encrypt_all root=/dev/disk/by-uuid/$UUID" \
    -device virtio-scsi-pci,id=scsi,disable-legacy=on \
    -drive file=$DISK,if=none,id=disk0,format=qcow2 \
    -device scsi-hd,drive=disk0 \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2022-:22 \
    -display none -vga none \
    -chardev stdio,id=char0,signal=off \
    -serial chardev:char0
