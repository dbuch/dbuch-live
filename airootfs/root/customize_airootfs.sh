#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

# cp -aT /etc/skel/ /root/

groupadd -rf sys
groupadd -rf realtime
groupadd -rf wheel
groupadd -rf nopasswdlogin

usermod -s /usr/bin/zsh root

echo "dbuchOS ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
useradd dbuchOS -p "dbuchOS" -g users -G "sys,realtime,wheel,nopasswdlogin" -s /usr/bin/zsh -m
#useradd dbuch-live -p "dbuch-live" -g users -G "sys,realtime,wheel,nopasswdlogin" -s /usr/bin/zsh -k /etc/skel.shadow -m

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service
systemctl enable choose-mirror.service
systemctl set-default graphical.target

systemctl enable dbus-broker.service
systemctl enable NetworkManager.service
systemctl enable gdm.service
systemctl enable iwd.service
systemctl enable systemd-resolved.service
systemctl enable systemd-networkd.service
systemctl enable bluetooth.service
