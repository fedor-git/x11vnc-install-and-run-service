#!/bin/sh
# Install x11vnc Service for Ubuntu, Xubuntu x86_64
# Service start automatically after script finishes
# You need got an account with sudo access to run it!
# You can change password PASSWD and name of service - SYSCTRL
# If you don't like standard vnc port you could change PORT
# Author Fedor Sorokin

SYSCTRL='/lib/systemd/system/x11vnc.service'
PASSWD='123456'
PORT='5900'

apt-get -f remove vino
apt-get install x11vnc -y && x11vnc -storepasswd $PASSWD /etc/x11vnc.pass && touch $SYSCTRL
apt-get -f -y install

if [ ! -f "$SYSCTRL" ]; then
    echo "Creating file $SYSCTRL"
cat <<EOT >> $SYSCTRL
[Unit]
Description=Start x11vnc at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc.pass -rfbport $PORT -shared

[Install]
WantedBy=multi-user.target
EOT
  echo "Reloading daemon"
  systemctl daemon-reload && systemctl enable x11vnc.service && systemctl start x11vnc.service && systemctl status x11vnc.service
    exit 0
 else
   echo "File $SYSCTRL already created! Reloading daemon!"
   systemctl daemon-reload && systemctl enable x11vnc.service && systemctl start x11vnc.service && systemctl status x11vnc.service
    exit 1
fi
