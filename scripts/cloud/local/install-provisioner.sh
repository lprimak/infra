#!/bin/bash -p

cat <<EOF > /etc/systemd/system/vagrant-provision.service
  [Unit]
  Description=Run provision script at boot

  [Service]
  Type=oneshot
  ExecStart=/usr/local/bin/vagrant-provision.sh
  RemainAfterExit=yes

  [Install]
  WantedBy=multi-user.target
EOF

cp /vagrant/vagrant-provision.sh /usr/local/bin/vagrant-provision.sh
chmod +x /usr/local/bin/vagrant-provision.sh
systemctl enable -q vagrant-provision.service
