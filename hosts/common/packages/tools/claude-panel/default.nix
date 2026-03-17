{ pkgs
, claudeUrl ? "https://claude.ai"
, windowClass ? "claude-panel"
, appName ? "Claude"
}:

pkgs.stdenv.mkDerivation {
  pname = "claude-panel";
  version = "1.0.0";

  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/claude-panel << EOF
#!${pkgs.bash}/bin/bash
exec ${pkgs.chromium}/bin/chromium \
  --user-data-dir="\$HOME/.config/${windowClass}" \
  --class="${windowClass}" \
  --app="${claudeUrl}" \
  --force-dark-mode \
  --enable-features=WebUIDarkMode \
  --no-first-run
EOF
    chmod +x $out/bin/claude-panel

    mkdir -p $out/share/applications
    cat > $out/share/applications/claude-panel.desktop << EOF
[Desktop Entry]
Type=Application
Name=${appName}
Comment=Claude AI standalone app
Exec=claude-panel
Terminal=false
Categories=Network;Chat;
StartupWMClass=${windowClass}
EOF
  '';
}
