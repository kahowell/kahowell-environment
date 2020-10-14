# install from the flash drive
install cdrom

# do graphical installation
graphical

# only touch nvme drives
ignoredisk --only-use=nvme01

# setup gpt
clearpart --disklabel gpt

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

%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%post
# unlock root without a pw for now
passwd -d root
echo "test -e /dev/disk/by-label/f32_install && mount /dev/disk/by-label/f32_install /mnt && /mnt/bootstrap.sh"

%end

reboot
