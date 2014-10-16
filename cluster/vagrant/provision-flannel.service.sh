#!/bin/sh

PRIVATE_IP=$1
NETMASK=10.100.0.0/16
FLANNEL_CONF=/etc/systemd/system/flannel.service

if ! which /opt/bin/flanneld >/dev/null 2>&1; then
      mkdir /opt/bin -p
      cp /home/core/share/bin/flanneld /opt/bin/
fi

if [[ ! -f "$FLANNEL_CONF" ]]; then
    cat <<EOF > ${FLANNEL_CONF}
[Unit]
Requires=etcd.service
After=etcd.service

[Service]
ExecStartPre=-/usr/bin/etcdctl set /coreos.com/network/config '{"Network":"${NETMASK}"}'
ExecStart=/opt/bin/flanneld -iface=${PRIVATE_IP}

[Install]
WantedBy=multi-user.target
EOF


    sudo systemctl enable ${FLANNEL_CONF}
    sudo systemctl daemon-reload
    sudo systemctl start flannel
else
    sudo systemctl restart flannel
fi