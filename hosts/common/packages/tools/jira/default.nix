{ pkgs
, jiraUrl ?
    "https://halon.atlassian.net/jira/software/c/projects/ENG/boards/1054?assignee=6112c4bd7ab143006e7d29f1&assignee=712020%3A063d9e20-5823-4ea0-9353-0d295627f385&assignee=unassigned"
, windowClass ? "jira-halon"
, appName ? "Jira (Halon)"
, icon ? ./jira-icon.png
}:

pkgs.stdenv.mkDerivation {
  pname = "jira-launcher";
  version = "1.0.0";

  # Bring the icon into the build
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    # Launcher script
    cat > $out/bin/jira << EOF
#!${pkgs.bash}/bin/bash
exec ${pkgs.chromium}/bin/chromium \
  --user-data-dir="\$HOME/.config/${windowClass}" \
  --class="${windowClass}" \
  --app="${jiraUrl}"
EOF
    chmod +x $out/bin/jira

    # Install icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${icon} $out/share/icons/hicolor/256x256/apps/jira.png

    # Desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/jira.desktop << EOF
[Desktop Entry]
Type=Application
Name=${appName}
Comment=Jira standalone app
Exec=jira
Terminal=false
Categories=Network;Chat;
StartupWMClass=${windowClass}
Icon=jira
EOF
  '';
}

