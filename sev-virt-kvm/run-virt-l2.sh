#!/bin/sh

QEMU=/usr/local/nsev/bin/qemu-system-x86_64
BIOS=/usr/local/nsev/bios/OVMF.fd
DISK=/usr/local/nsev/images/l2-vm.qcow2

MEM=2G

rmmod kvm-amd
rmmod kvm

modprobe -v kvm mmio_caching=1 force_sev_cpuid=N
modprobe -v kvm-amd dump_invalid_vmcb=1 sev=1 vte=Y

modprobe -v sev-shared

$QEMU \
    -enable-kvm \
    -smp 2 -m $MEM \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    -object memory-backend-file,id=ram1,size=2G,mem-path=/dev/sev-shared,prealloc=off,share=on,readonly=off \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,mem-path=/dev/sev-shared \
    -cpu host,host-cache-info=on \
    -bios $BIOS \
    -device virtio-scsi-pci,id=scsi,disable-legacy=on \
    -drive file=$DISK,if=none,id=disk0,format=qcow2 \
    -device scsi-hd,drive=disk0 \
    -device virtio-net-pci,netdev=tap0,id=virbr0,romfile= \
    -netdev tap,id=tap0,helper=/usr/lib/qemu/qemu-bridge-helper,vhost=on,br=virbr0 \
    -vga none -display none -nographic -nodefaults -serial stdio
