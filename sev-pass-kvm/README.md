# SEV Passthrough with KVM

## Install L1 KVM

1. Install the Linux kernel with support for nested SEV in the L1 VM.
   This is the same kernel as L0 KVM.  If you build this kernel in the
   L1 VM, follow the instruction for building L0 KVM.

2. Build and install the mem32 kernel module in the L1 VM.

   ```
   git clone https://github.com/ksl-kyutech/nsev-linux-mem32.git
   cd nsev-linux-mem32
   make
   sudo cp mem32.ko /usr/local/nsev/images
   ```

3. Reboot the L1 VM with the kernel.

## Build L1 QEMU

Build and install QEMU with support for SEV passthrough in the L1 VM.
If you want to coexist with QEMU with support for SEV virtualization,
change the prefix.

```
git clone https://github.com/ksl-kyutech/nsev-qemu-kvm-l1.git
cd nsev-qemu-kvm-l1
mkdir build
cd build
../configure --prefix=/usr/local/nsev --target-list=x86_64-softmmu --enable-kvm
make -j$(nproc)
sudo make install
```

## Build L2 Boot Loader

Build and install the custom boot loader for SEV passthrough in the L1
VM.

```
git clone https://github.com/ksl-kyutech/nsev-bootloader-kvm-l2.git
cd nsev-bootloader-kvm-l2
make
sudo cp bios.bin /usr/local/nsev/bios
```

## Build L2 Linux

Build and install the Linux kernel with support for SEV passthrough in
the L1 VM.

```
git clone https://github.com/ksl-kyutech/nsev-linux-kvm-l2.git
cd nsev-linux-kvm-l2
make -j$(nproc)
sudo cp arch/x86/boot/bzImage /usr/local/nsev/images

sudo make modules_install
sudo update-initramfs -c -k $(make kernelrelease) -b .
sudo mv initrd.img-$(make kernelrelease) /usr/local/nsev/images/initrd.img
```

## Boot L2 VM

1. Create an L2 VM image as l2-vm.qcow2.

2. Place the image in /usr/local/nsev/images of the L1 VM.

3. Copy nested-sev/sev-pass-kvm/run-pass-l2.sh to the L1 VM.

4. Check the image's UUID and set UUID in run-pass-l2.sh.

   ```
   sudo modprobe nbd max_part=8
   qemu-nbd --connect=/dev/nbd0 /usr/local/nsev/images/l2-vm.qcow2
   blkid /dev/nbd0*
   qemu-nbd --disconnect /dev/nbd0
   ```

5. Run the script to boot an L2 VM with L1 KVM, L1 QEMU, L2 boot
   loader, and L2 Linux.

   ```
   sudo ./run-pass-l2.sh
   ```

6. Log in to the L2 VM using SSH.

   ```
   ssh -p 2022 localhost
   ```

