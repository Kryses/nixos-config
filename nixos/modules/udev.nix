{ pkgs, ... }:

{
  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "cdrom.autoeject=0"
    "cdrom.lock=0"
  ];

  boot.kernel.sysctl = {
    "dev.cdrom.autoclose" = 0;
  };

  services.udev = {
    enable = true;

    packages = [
      pkgs.qmk
      pkgs.qmk-udev-rules
      pkgs.qmk_hid
      pkgs.via
      pkgs.vial

      # 1️⃣ MASK systemd's cdrom_id rules entirely
      (pkgs.writeTextFile {
        name = "mask-cdrom-id";
        destination = "/etc/udev/rules.d/60-cdrom_id.rules";
        text = ''
          # masked by NixOS — cdrom_id disabled
        '';
      })

      # 2️⃣ Minimal replacement rule (NO tray locking, NO probing)
      (pkgs.writeTextFile {
        name = "optical-basic";
        destination = "/etc/udev/rules.d/61-optical-basic.rules";
        text = ''
          ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sr0", \
            ENV{ID_CDROM}="1", \
            ENV{SYSTEMD_READY}="1", \
            OPTIONS+="nowatch"
        '';
      })
    ];
  };

  users.groups.plugdev = {};
}
