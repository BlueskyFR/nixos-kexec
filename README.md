# Installing NixOS on the Android Linux Terminal

Inspired, upgraded & adapted from [this tutorial](https://blog.korfuri.fr/posts/2022/08/nixos-on-an-oracle-free-tier-ampere-machine/).

Basically, kexec is a Linux Kernel feature that allows you to execute and
switch to another kernel from the running one, so you can do cool things such
as replacing the running distribution with another one like NixOS ;)

First, enable the Linux Terminal from the Android developer settings!
Then run it and let it download & setup its base image.

> FYI your phone's architecture is generally aarch64 (arm64).

Much of the code of this repo is copied & upgraded from cleverca22's awesome nix-tests repo here: [https://github.com/cleverca22/nix-tests](https://github.com/cleverca22/nix-tests/tree/master/kexec).

## Enabling SSH access

The default Linux Terminal behavior is a bit weird it seems that sessions
are not that persistent, plus the app is not great.

Something lovely would be to allow SSH connections to use an app like JuiceSSH which handles background connections like no one else, so let's do that!

Note that the LT has an ip of `192.168.0.2/24` and its gateway (your phone) is `192.168.0.1`. This means SSH access will only be possible from your phone.

From there, I use an app like **tmate** and/or a VSCode tunnel to provide an external access.

1. Enable SSH access
```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl enable --now ssh
# Check that sshd effectively listens
sudo ss -tap | grep -i ssh
```

2. Set a password for your user
```bash
sudo passwd droid
```

3. Connect from your phone, using an app like **JuiceSSH**
```bash
ssh droid@192.168.0.2
```

4. From **JuiceSSH**, provide access to a terminal on your computer using **tmate**:
```bash
sudo apt install tmate
tmate -F
```
And then copy the full access SSH command.

## Remote access from VSCode

It's just cool to be able to do everything from VSCode and a terminal
on a computer instead of using the super small keyboard of your phone :D

```bash
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm64' --output vscode_cli.tar.gz
tar xf vscode_cli.tar.gz
./code tunnel
```

Then run `Connect to Tunnel...` from VSCode once you successfully registered the new tunnel host on your Github/Microsoft account.

## NixOS kexec

1. Multi-user Nix installation:
```bash
bash <(curl -L https://nixos.org/nix/install) --daemon
```

2. Clone this repo and `cd` into it ;)
```bash
git clone git@github.com:BlueskyFR/nixos-kexec && cd nixos-kexec
```

3. Build the kexec tarball/ramdisk.
The goal is to boot (using kexec) the VM on a ramdisk containing NixOS.
```bash
nix-build '<nixpkgs/nixos>' -A config.system.build.kexec_tarball -I nixos-config=./main.nix

```