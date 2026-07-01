# SEV Virtualization with KVM

## Install L1 KVM

1. Install the Linux kernel with support for SEV virtualization in the
   L1 VM.  This is the same kernel as L0 KVM.  If you build this
   kernel in the L1 VM, follow the instruction for [building L0
   KVM](#build-l0-kvm).

2. Reboot the L1 VM with the kernel.

## Install L1 QEMU

Install QEMU with support for SEV virtualization in the L1 VM.  This
is the same as L0 QEMU.  If you build this QEMU in the L1 VM, follow
the instruction for [building L0 QEMU](#build-l0-qemu).

## Boot L2 VM

1. Create an L2 VM image as l2-vm.qcow2.

2. Place the image in /usr/local/nsev/images of the L1 VM.

3. Copy nested-sev/kvm-virt/run-virt-l2.sh to the L1 VM.

4. Run the script to boot an L2 VM with L1 KVM and L1 QEMU.

   ```
   sudo ./run-virt-l2.sh
   ```

