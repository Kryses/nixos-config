{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "kryses";
    homeDirectory = "/home/kryses";
    stateVersion = "25.05";
  };
  systemd.user.services.stable-diffusion-web-ui = {
    Unit = {
      Description = "Stable Diffusion Web Ui";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      Restart = "always";
      ExecStart = "${pkgs.writeShellScript "stable-diffusion-web-ui" ''
        stable-diffusion-webui --api --share --listen

      ''}";
    };
  };
}
