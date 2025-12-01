{ pkgs
, gatherUrl ?
    "https://app.v2.gather.town/app/halon-61af8bed-9d91-4e9f-9f54-eddb8cc02782"
, windowClass ? "gather-halon"
, appName ? "Gather Town (Halon)"
, icon ? ./gather-icon.png
}:

pkgs.stdenv.mkDerivation {
  pname = "gather-town-launcher";
  version = "1.0.0";

  # Bring the icon into the build
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    # Launcher script
    cat > $out/bin/gather-town << EOF
#!${pkgs.bash}/bin/bash
exec ${pkgs.chromium}/bin/chromium \
  --user-data-dir="\$HOME/.config/${windowClass}" \
  --class="${windowClass}" \
  --app="${gatherUrl}"
EOF
    chmod +x $out/bin/gather-town

    # Install icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${icon} $out/share/icons/hicolor/256x256/apps/gather-town.png

    # Desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/gather-town.desktop << EOF
[Desktop Entry]
Type=Application
Name=${appName}
Comment=Gather Town standalone app
Exec=gather-town
Terminal=false
Categories=Network;Chat;
StartupWMClass=${windowClass}
Icon=gather-town
EOF
  '';
}

