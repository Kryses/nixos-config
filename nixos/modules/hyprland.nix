{ pkgs, ... }:
let
  # Remove the bundled Qt share-picker so XDPH uses custom_picker_binary from config
  xdph-no-picker = pkgs.xdg-desktop-portal-hyprland.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      rm -f $out/bin/hyprland-share-picker
    '';
  });
in {
  programs.hyprland = {
    enable = true;
    # Use our patched XDPH without the Qt picker
    portalPackage = xdph-no-picker;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "hyprland" "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };
}
