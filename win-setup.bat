setx WSLENV BASH_ENV/u
setx BASH_ENV /etc/bash.bashrc

wsl --terminate Ubuntu-20.04
wsl --list --running