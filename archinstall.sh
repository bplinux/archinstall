#!/bin/bash
echo "Setting key with loadkeys"
loadkeys de-latin1

echo "Setting up encrypted harddrive"
modprobe dm-crypt
cryptsetup luksOpen /dev/nvme0n1p2 lvm
mkfs.ext4 -L root /dev/mapper/lvm-root

echo "Mounting everything together"
mkdir /mnt/home
mkdir /mnt/boot
mount /dev/mapper/lvm-root /mnt
mount /dev/mapper/lvm-home /mnt/home
swapon /dev/mapper/lvm-swap

echo "Installing linux...."
pacstrap /mnt base base-devel dosfstools gptfdisk lvm2 linux linux-firmware dhcpcd vim dialog wpa_supplicant netctl

echo "Generating config files"
genfstab -Lp /mnt > /mnt/ets/fstab
echo "pucki-arch" > /mnt/etc/hostname
vim /mnt/etc/locale.gen
echo "KEYMAP=de-latin1" > /mnt/etc/vconsole.conf

echo "Setting bootloaderconfig"
echo "title	Arch Linux" > /mnt/boot/loader/entries/arch.conf
echo "linux    /vmlinuz-linux" >> /mnt/boot/loader/entries/arch.conf
echo "initrd   /initramfs-linux.img" >> /mnt/boot/loader/entries/arch.conf
echo "options  cryptdevice=/dev/nvme0n1p2:lvm root=/dev/mapper/lvm-root rw lang=de init=/usr/lib/systemd/systemd locale=de_DE.UTF-8">>/mnt/boot/loader/entries/arch.conf

echo "default arch.conf" >> /mnt/boot/loader/loader.conf

echo "Changing Root"
echo "ToDo: locale-gen..."
echo "ToDo: ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime"
echo "ToDo: /etc/mkinitcpio.conf..."
echo "MODULES (ext4)"
echo "HOOKS=(base udev autodetect modconf block keyboard keymap encrypt lvm2 filesystems fsck shutdown)"
echo "ToDo mkinitcpio -p linux"
echo "ToDo passwd"

arch-chroot /mnt
