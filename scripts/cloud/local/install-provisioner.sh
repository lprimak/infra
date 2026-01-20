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

curl https://raw.githubusercontent.com/lprimak/infra/main/scripts/cloud/local/vagrant-provision.sh \
--silent -o /usr/local/bin/vagrant-provision.sh
chmod +x /usr/local/bin/vagrant-provision.sh
systemctl enable -q vagrant-provision.service

if [ -f /etc/ssh/sshd_config.d/50-cloud-init.conf ]; then
  # Update PasswordAuthentication to 'yes'
  sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf

  # Restart SSH service to apply changes
  systemctl restart sshd
fi

# Change the password for the 'vagrant' user
echo "vagrant:vagrant" | chpasswd
