#!/bin/sh

QEMU=/usr/local/nsev/bin/qemu-system-x86_64
BIOS=/usr/local/nsev/bios/OVMF.fd
DISK=/usr/local/nsev/images/l1-vm.qcow2

MEM=8G

rmmod kvm-amd
rmmod kvm

modprobe -v kvm optimize_nested_mmio_passthrough=1 unsync_non_leaf=Y map_reserved_entry=Y
modprobe -v kvm-amd vls=1

$QEMU \
    -smp 8 -m $MEM -enable-kvm \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1,smm=off,mem-merge=off \
    -object memory-backend-memfd,id=ram1,size=$MEM,share=true,reserve=on \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1 \
    -cpu host,-la57,+invtsc,+decodeassists,-virt-ssbd,-spec-ctrl,-stibp,-arch-capabilities,-ssbd,-tsc-adjust,-tsc-deadline,host-cache-info=on,-pmu \
    -bios $BIOS \
    -device amd-psp \
    -device virtio-scsi-pci,id=scsi,disable-legacy=on,iommu_platform=true \
    -drive file=$DISK,if=none,id=disk0,format=qcow2 \
    -device scsi-hd,drive=disk0 \
    -device virtio-net-pci,netdev=net0,id=virbr0,romfile= \
    -netdev bridge,id=net0,br=virbr0,helper=/usr/lib/qemu/qemu-bridge-helper \
    -display none -vga none -serial stdio
