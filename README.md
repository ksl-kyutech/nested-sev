# Nested SEV

Nested SEV provides secure and generic SEV support for nested
virtualization.  It allows SEV-enabled L2 VMs to run inside an
SEV-enabled L1 VM.  It supports two trust models: (1) both the L0 and
L1 hypervisors are untrusted, and (2) the L0 hypervisor is untrusted
but the L1 hypervisor is trusted.  For these trust models, nested SEV
provides two mechanisms: SEV virtualization and SEV passthrough.  SEV
virtualization applies virtual SEV to an L2 VM and protects its memory
and register state using a different SEV context from that of the L1
VM, e.g., an encryption key.  As a result, it protects L2 VMs against
both the L0 and L1 hypervisors.  In contrast, SEV passthrough
partially virtualizes SEV and uses the same SEV context as the L1 VM.
It protects L2 VMs against the L0 hypervisor but allows the L1
hypervisor to access the internal state of L2 VMs.

<a id="build-l0-kvm"></a>
## Build L0 KVM

1. Build and install the Linux kernel with support for nested SEV on
   the host.

   ```
   git clone https://github.com/ksl-kyutech/nsev-linux.git
   cd nsev-linux
   make oldconfig
   make
   sudo make modules_install
   sudo make install
   ```

   Check that the following configs are enabled.

   ```
   CONFIG_SEV_SHARED=m
   CONFIG_SNP_MEM=m
   ```

2. Reboot the host with the kernel.

<a id="build-l0-qemu"></a>
## Build L0 QEMU

Build and install QEMU with support for nested SEV on the host.

```
git clone https://github.com/ksl-kyutech/nsev-qemu.git
cd nsev-qemu
mkdir build
cd build
../configure --prefix=/usr/local/nsev --target-list=x86_64-softmmu --enable-kvm
make
sudo make install
```

## Build L1 OVMF

Build OVMF with support for SEV-SNP.

```
git clone https://github.com/tianocore/edk2.git
cd edk2
git submodule update --init --recursive
make -C BaseTools
source edksetup.sh
build -p OvmfPkg/OvmfPkgX64.dsc -a X64 -t GCC -b DEBUG
sudo mkdir -p /usr/local/nsev/bios
sudo cp Build/OvmfX64/DEBUG_GCC/FV/OVMF.fd /usr/local/nsev/bios
```

## Boot L1 VM

1. Create an L1 VM image with Ubuntu 24.04.

2. Rename the image name to l1-vm.qcow2 and place it in
   /usr/local/nsev/images.

3. Run the following script to boot an L1 VM with L0 KVM, L0 QEMU, and
   L1 OVMF.

   ```
   sudo ./run-l1.sh
   ```

## Next Step

- [SEV Virtualization with KVM](https://github.com/ksl-kyutech/nested-sev/blob/main/sev-virt-kvm/README.md)
- [SEV Passthrough with KVM](https://github.com/ksl-kyutech/nested-sev/blob/main/sev-pass-kvm/README.md)
- [SEV Virtualization with BitVisor](https://github.com/ksl-kyutech/nested-sev/blob/main/sev-virt-bv/README.md)
- [SEV Passthrough with BitVisor](https://github.com/ksl-kyutech/nested-sev/blob/main/sev-pass-bv/README.md)
- [SEV Passthrough with Xen](https://github.com/ksl-kyutech/nested-sev/blob/main/sev-pass-xen/README.md)

## Publication
```
@InProceedings{Takiguchi26,
  author = {K. Takiguchi and K. Kourai},
  title = {Nested SEV: Secure and Generic SEV Support for Nested Virtualization},
  booktitle = {Proceedings of the 20th USENIX Symposium on Operating Systems Design and Implementation (OSDI'26)},
  pages = {1051--1066},
  year = {2026},
}
```

