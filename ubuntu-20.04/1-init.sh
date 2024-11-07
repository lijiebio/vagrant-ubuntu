timedatectl set-timezone Asia/Shanghai


mv /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.bak
cat <<EOF >/etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      nameservers:
        addresses: [1.2.4.8, 210.2.4.8]
EOF
netplan apply

mv /etc/systemd/resolved.conf /etc/systemd/resolved.conf.bak
systemctl restart systemd-resolved


sed -e 's|us.archive.ubuntu.com|mirrors.cernet.edu.cn|g' \
	-e 's|security.ubuntu.com|mirrors.cernet.edu.cn|g' \
	-i.bak \
	/etc/apt/sources.list
apt update


rm -f /boot/initrd.img-*.img

apt -y remove linux-headers-generic linux-image-5.4.0-169-generic linux-image-generic
apt -y remove linux-cloud-tools-common linux-tools-common
apt -y autoremove


apt -y upgrade

apt -y install build-essential python3 python3-pip python3-venv
cat <<EOF >/etc/pip.conf
[global]
index-url = https://mirrors.cernet.edu.cn/pypi/web/simple
EOF
