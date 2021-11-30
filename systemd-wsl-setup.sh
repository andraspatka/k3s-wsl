#!/bin/bash

echo "Installing required dependencies"

sudo apt-get update && sudo apt-get install -yqq daemonize dbus-user-session fontconfig

echo "Copying scripts, adding execute permissions"

sudo cp start-systemd-namespace /usr/sbin/start-systemd-namespace && \
sudo cp enter-systemd-namespace /usr/sbin/enter-systemd-namespace && \
sudo chmod +x /usr/sbin/start-systemd-namespace && \
sudo chmod +x /usr/sbin/enter-systemd-namespace

# ToDo: visudoers

sudo sed -i 2a"# Start or enter a PID namespace in WSL2\nsource /usr/sbin/start-systemd-namespace\n" /etc/bash.bashrc

logout