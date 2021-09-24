# wsl-vpn

**This was taken from: https://github.com/AmmarRahman/wsl-vpn and modified.**

This is a repository to script in the workaround for WSL2 connectivity over VPN based on [Keiichi Shimamura](https://github.com/sakai135/wsl-vpnkit) work  on Ubuntu and Debian WSL Distros.

The solution utilises [Docker's VPNKit](https://github.com/moby/vpnkit) and [Jeff Trotman's npiperelay](https://github.com/jstarks/npiperelay) to tunnel the connectivity

## Getting started

1. Disconnect from the VPN
2. Install socat: `sudo apt-get update && sudo apt-get install socat`
3. Run the script with: `sudo ./wsl-vpnkit-setup.sh --no-docker`
   1. `--no-docker` option: doesn't require an installation of Docker desktop (this is what we want to avoid), instead it just gets the required files (wsl-vpnkit.exe and npiperelay.exe)
4. Connect to the VPN
5. Test by running: `ping google.com` If it doesn't return an error, then it worked!

Once everything is working and you are satisfied, you can feel free to remove the cloned repository; all relavent files have been installed (However, you cannot delete `C:\bin\` in Windows)

## Removal

In case you want to remove and/or re-install the wsl-vpn files, you can run:

1. In the cloned repo, run:
    - `sudo ./wsl-vpnkit-unsetup.sh`

## FAQ

1. What if I have multiple WSLs?
    - You only install WSL-VPN into one WSL2 distro. The rest of the distros will get working internet from the WSL-VPN distro.
    - The only caveat is that you must start the WSL-VPN distro everytime you restart your computer or "shutdown" or "terminate" the WSL-VPN distro.
    - Simply opening up a tab to the WSL-VPN distro starts and fixes all of the other WSL2 distros. You can close it as soon as you open it.
    - If you need to script starting WSL-VPN: `/mnt/c/Windows/System32/wsl.exe -d {WSL-VPN distro name} --user root service wsl-vpnkit start`
2. What if I'm trying to expose a port from WSL2?
    - Unforunately, this solution will not allow you to expose a port when on or off of VPN. If you need to expose a port when off of VPN, you'll need to run the `./wsl-vpnkit-unsetup.sh` script
3. What about IPv6?
    - On tested clients IPv6 actually works when on VPN without the need for WSL-VPN, and continues to work when WSL-VPN is fixing IPv4. Tested clients include:
        - SonicWall NetExtender
    - Exposing ports on IPv6 still works
4. What if I started killing random parts of the WSL-VPN, and now nothing's working.
    - Well, if the scripts are killed mid-script, they can't restore settings. But to fix this, you simply run: `wsl --shutdown` and everything will be restored.
    - **Note**: This will restart _all_ WSLs. I.e. if you are running docker, it will be restarted.

## Troubleshooting

mv error:
```
mv: cannot move 'wsl-vpnkit.exe' to '/mnt/c/bin/wsl-vpnkit.exe': Permission denied
```
Make sure that C:\bin is empty!


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit)
* [vpn-kit](https://github.com/moby/vpnkit)
* [npiperelay](https://github.com/jstarks/npiperelay)
