# KVM-SSH
A very simple bash script for automating the process of starting and connecting to KVM/QEMU Virtual Machines via ssh.
# Dependencies
* KVM
* QEMU
* AWK
* OpenSSH

On *Debian* or *Ubuntu*; use `apt-get`
```bash
$ sudo apt-get install qemu-system libvirt-clients libvirt-daemon-system bridge-utils iptables gawk openssh-server
```
### More info can be found on [Debian Wiki](https://wiki.debian.org/KVM)

On *Arch Linux* or *Manjaro*; use `pacman`
```bash
$ sudo pacman -S --needed virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils vde2 iptables-nft gawk openssh
```
### More info can be found on [ArchWiki](https://wiki.archlinux.org/title/QEMU)

# Usage
`sh kvm-ssh.sh <VM name>`
