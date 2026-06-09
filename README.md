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
  year = {2026},
}
```

