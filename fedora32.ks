# install from the flash drive
install cdrom

# do graphical installation
text

# only touch nvme drive
ignoredisk --only-use=nvme0n1

# setup gpt
clearpart --disklabel gpt --all

# clear disk
zerombr

# do btrfs partitioning, encrypt with passphrase "password" for now (will reset during bootstrap)
autopart --type=btrfs --encrypted --passphrase=password

# install grub2
bootloader --location=mbr

# set up local user only
authselect select minimal

# lock root (for now)
rootpw --lock

# QWERTY keyboard layout
keyboard --xlayouts='us'

# locale
lang en_US.UTF-8

# ET by default
timezone America/New_York --ntpservers=pool.ntp.org

%packages
@core
@standard
@hardware-support
NetworkManager-wifi

%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%post
# unlock root without a pw for now
passwd -d root

echo "test -f /root/bootstrapped || (test -e /dev/disk/by-label/f32_install && mount /dev/disk/by-label/f32_install /mnt && /mnt/ansible-kahowell/bootstrap.sh && touch /root/bootstrapped; umount /mnt)" >> /root/.bashrc
cat << EOF > /etc/NetworkManager/conf.d/99-iwd.conf
[device]
wifi.backend=iwd
EOF

%end

reboot
