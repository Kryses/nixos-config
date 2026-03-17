{ pkgs
, chatgptUrl ? "https://chat.openai.com"
, windowClass ? "chatgpt-scratch"
, appName ? "ChatGPT"
, icon ? ./chatgpt-icon.png
}:

pkgs.stdenv.mkDerivation {
  pname = "chatgpt-launcher";
  version = "1.0.0";

  # Bring the icon into the build
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    # Launcher script
    cat > $out/bin/chatgpt << EOF
#!${pkgs.bash}/bin/bash
exec ${pkgs.chromium}/bin/chromium \
  --user-data-dir="\$HOME/.config/${windowClass}" \
  --class="${windowClass}" \
  --app="${chatgptUrl}"
EOF
    chmod +x $out/bin/chatgpt

    # Install icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${icon} $out/share/icons/hicolor/256x256/apps/chatgpt.png

    # Desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/chatgpt.desktop << EOF
[Desktop Entry]
Type=Application
Name=${appName}
Comment=ChatGPT standalone app
Exec=chatgpt
Terminal=false
Categories=Network;Chat;Development;
StartupWMClass=${windowClass}
Icon=chatgpt
EOF
  '';
}

