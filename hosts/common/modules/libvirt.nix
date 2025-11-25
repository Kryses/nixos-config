{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    sshProxy = false;
    qemu.swtpm.enable = true;
  };

  # Auto-start libvirt default network

  users.groups.libvertd.members = ["root" "kryses"];

  environment.systemPackages = with pkgs; [
    virtiofsd
  ];

  programs.ssh.systemd-ssh-proxy.enable = false;
}
