{
  imports = [
    ./configuration.nix
  ];

  # Make it use predictable interface names starting with eth0
  boot.kernelParams = [ "net.ifnames=0" ];

  networking.useDHCP = true;

  kexec = {
    autoReboot = false;
    # Linux Terminal-specific
    justdoit.rootDevice = "/dev/vda1";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYwklVEP79yh13YQuye4cwjbMd1uKSqKXlMd1iEHLrt JuiceSSH"
  ];
}