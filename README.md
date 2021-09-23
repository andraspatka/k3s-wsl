# Get k3s working on wsl2 Ubuntu 20.04

Requirements:
- WSL2: https://docs.microsoft.com/en-us/windows/wsl/install
- Ubuntu 20.04 from the Microsoft store: https://www.microsoft.com/en-us/p/ubuntu-2004-lts/9n6svws3rx71?activetab=pivot:overviewtab

## systemd

Install some dependencies:
```
sudo apt-get update && sudo apt-get install -yqq daemonize dbus-user-session fontconfig
```

Copy the necessary scripts:
```
sudo cp start-systemd-namespace /usr/sbin/start-systemd-namespace && \
sudo cp enter-systemd-namespace /usr/sbin/enter-systemd-namespace && \
sudo chmod +x /usr/sbin/start-systemd-namespace && \
sudo chmod +x /usr/sbin/enter-systemd-namespace
```


Copy-paste the contents of sudoers to /etc/sudoers. You can only do it with:

```bash
sudo visudo
```

Make sure start-systemd-namespace is executed when starting a bash session:
```bash
sudo sed -i 2a"# Start or enter a PID namespace in WSL2\nsource /usr/sbin/start-systemd-namespace\n" /etc/bash.bashrc
```

Set the following environment variables in a command line:

```
setx WSLENV BASH_ENV/u
setx BASH_ENV /etc/bash.bashrc
```

Logout from wsl2 Ubuntu 20.04
```bash
logout
```

Terminate the Ubuntu instance and make sure it's not running:

```cmd
wsl --terminate Ubuntu-20.04
wsl --list --running
```

## k3s

Install k3s in WSL by running:
```bash
curl -sfL https://get.k3s.io | sh -
```

Copy the kube config from wsl to your windows host. 
```bash
# Save previous kube config file, don't want to get overwritten
cp /mnt/c/Users/andra/.kube/config /mnt/c/Users/<user>/.kube/config-backup
# checkout k3s kube config file
sudo cat /etc/rancher/k3s/k3s.yaml
# copy the k3s kube config file to user directory
sudo cp /etc/rancher/k3s/k3s.yaml /mnt/c/Users/<user>/.kube/config

# get the ip address of WSL
ip addr show dev eth0
# replace localhost ip address (127.0.0.1) with WSL's from the previous command
sed -i -e 's/127.0.0.1/<ip-from-prev-command>/g' /mnt/c/Users/<user>/.kube/config
```

## Troubleshooting

Running bash in a broken WSL:
```
wsl bash --norc
```

In case the scripts that you copied cause WSL not to start, you can always delete them manually from windows.


### Acknowledgements

#### Scripts: enter-systemd-namespace, start-systemd-namespace

Taken from: https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033/4

#### Fix for scripts so that they work with Ubuntu-20.04 

Taken from: Reddit user **inspeculation**, https://www.reddit.com/r/bashonubuntuonwindows/comments/gc8lle/usrsbindaemonize_no_such_file_or_directory/ thread.

**Note:** the fixes from this thread are already incorporated to **enter-systemd-namespace** and **start-systemd-namespace**.

```
Going forward (for you and others who try this), a couple of tweaks are needed for this to work with 20.04.

First, the original author has updated his scripts fairly regularly, he's clear about the process, and there's a helpful comment thread, so get his code here:https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033

Outline of the steps: install three things, add two bash script files to /usr/sbin (one with chmod +x), alter sudoers in visudo, add a line to .bashrc, and add two environment variables.

(If you've done this process before on the same computer -- I did it on an 18.04 that started life pre-WSL2 as Ubuntu 16.04, now doing it on a WSL Ubuntu 20.04 -- those variables will already be set, but there's no harm in making sure.)

The scripts reference the .systemd-env file, so before you do anything with the scripts, make sure you have one even if it's empty. It should be placed at /root

Further advice: check every character in the scripts after copy-pasting and before saving. It only takes a couple of minutes and could prevent you mangling your distro. I noticed a weirdly formatted line after pasting in one of them; it turned out to have a few duplicated characters. It only happened once but that's a big yikes amirite.

Okay, the tweaks...

ps -ef should be ps -efw: According to the latest comment, the `ps -ef` commands (there are three at last count) need to be changed to `ps -efw`. 'Without that “-w” the output is truncated, one of the calls will fail to find in start, the other will succeed and will not spawn anything, which causes my gnome-terminal sessions to instantly close after the first one.'

daemonize has moved: as the OP discovered, daemonize now installs to /usr/bin rather than /usr/sbin, so the reference to it in the enter-systemd-namespace script needs to be changed.

After completing all the steps, I exited bash, ran wsl --shutdown in PowerShell for good measure, and rebooted Windows just in case. It's working with no discernible issues.
```

#### Steps on how to reach k3s from Windows

Taken from: https://gist.github.com/ibuildthecloud/1b7d6940552ada6d37f54c71a89f7d00