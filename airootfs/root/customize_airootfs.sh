#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

cp -aT /etc/skel/ /root/

groupadd -rf sys
groupadd -rf realtime
groupadd -rf wheel
groupadd -rf nopasswdlogin

usermod -s /usr/bin/zsh root

useradd -m -p "" -g users -G "sys,realtime,wheel,nopasswdlogin" -s /bin/zsh dbuch-live
chown -R dbuch-live:users /home/dbuch-live

#chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service NetworkManager.service gdm.service iwd.service systemd-resolved.service
systemctl set-default multi-user.target
