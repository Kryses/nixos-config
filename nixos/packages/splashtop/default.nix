{ lib
, pkgs
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook
, alsa-lib
, at-spi2-atk
, at-spi2-core
, cairo
, cups
, curl
, dbus
, expat
, ffmpeg
, fontconfig
, freetype
, glib
, glibc
, gtk3
, gtk4
, libcanberra
, liberation_ttf
, libexif
, libglvnd
, libkrb5
, libnotify
, libpulseaudio
, libu2f-host
, libva
, libxkbcommon
, mesa
, nspr
, nss
, pango
, pciutils
, pipewire
, qt6
, speechd
, udev
, _7zz
, vaapiVdpau
, vulkan-loader
, wayland
, wget
, xfce
, xorg
}:

stdenv.mkDerivation {
  name = "splashtop-business";
  src = fetchurl {
    url = "https://download.splashtop.com/linuxclient/splashtop-business_Ubuntu_v3.7.2.0_amd64.tar.gz";
    hash = "sha256-RRu3ZW3vUSnv6JBinq3KtGLUIHvUOolV2xy5oTytTt4=";
  };

  dontBuild = true;
  dontConfigure = true;
  dontWrapGApps = true;
  dontWrapQtApps = true;
  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
    "wrapProgramPhase"
  ];
  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    curl
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    glib
    glibc
    gtk3
    gtk4
    libcanberra
    liberation_ttf
    libexif
    libglvnd
    libkrb5
    libnotify
    libpulseaudio
    libu2f-host
    libva
    libxkbcommon
    mesa
    nspr
    nss
    pango
    pciutils
    pipewire
    speechd
    udev
    _7zz
    vaapiVdpau
    vulkan-loader
    wayland
    wget
    xfce.exo
    xorg.libxcb
    xorg.xcbutil
    xorg.libX11
    xorg.libXcursor
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libxcb
    xorg.xcbutilkeysyms
  ];

  unpackPhase = ''
    tar zxf $src
    ar -x splashtop-business_Ubuntu_amd64.deb
    tar xf data.tar.xz
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -vr opt $out
    cp -vr usr/* $out
    mkdir $out/bin
    ln -s $out/opt/splashtop-business/splashtop-business $out/bin/splashtop-business
    substituteInPlace $out/share/applications/splashtop-business.desktop \
      --replace /usr/bin $out/bin \
      --replace Icon=/usr/share/pixmaps/logo_about_biz.png Icon=$out/share/pixmaps/logo_about_biz.png
  '';

  wrapProgramPhase = ''
    echo ${pkgs.xorg.libxcb}/lib
    wrapProgram $out/bin/splashtop-business \
      --set QT_QPA_PLATFORM "wayland" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath [
      pkgs.xorg.xcbutil
      pkgs.xorg.libxcb
      xorg.xcbutilkeysyms
      pkgs.keyutils
      pkgs.libcap
      pkgs.xdotool
      pkgs.libpulseaudio
      pkgs.libsForQt5.qt5.qtbase
      pkgs.libsForQt5.qt5.qtwayland
    ]}:$out/opt/splashtop-business/lib/msquic:$out/opt/splashtop-business/lib/fips:$out/opt/splashtop-business/lib/legacy:$LD_LIBRARY_PATH"
  '';

  meta = with lib; {
    homepage = "https://www.splashtop.com/products/business-access";
    downloadPage = "https://support-splashtopbusiness.splashtop.com/hc/en-us/articles/4404715685147";
    description = "Remotely access your desktop from any device from anywhere!";
    license = licenses.unlicense;
    platforms = [ "x86_64-linux" ];
  };
}
# new Debian package, version 2.0.
# size 4695790 bytes: control archive=1774 bytes.
#     882 bytes,    11 lines      control
#     881 bytes,    11 lines      md5sums
#    1226 bytes,    39 lines   *  postinst             #!/bin/sh
#     155 bytes,     7 lines   *  postrm               #!/bin/sh
#     262 bytes,    19 lines   *  preinst              #!/bin/sh
#     274 bytes,    19 lines   *  prerm                #!/bin/sh
#      31 bytes,     1 lines      shlibs
#      60 bytes,     2 lines      triggers
# Package: splashtop-business
# Version: 3.7.2.0
# Architecture: amd64
# Maintainer: Splashtop Inc. <build@splashtop.com>
# Installed-Size: 20841
# Depends: curl (>= 7.47.0)
# libc6 (>= 2.14)
# libgcc1 (>= 1:3.0)
# bash-completion
# libkeyutils1 (>= 1.5.6)
# libqt5core5a (>= 5.5.0)
# libqt5gui5 (>= 5.0.2) | libqt5gui5-gles (>= 5.0.2)
# libqt5network5 (>= 5.0.2)
# libqt5widgets5 (>= 5.4.0)
# libstdc++6 (>= 5.2)
# libxcb-keysyms1 (>= 0.4.0)
# libxcb-randr0 (>= 1.3)
# libxcb-shm0
# libxcb-util1 (>= 0.4.0)
# libxcb-xfixes0
# libxcb-xtest0
# libxcb1
# libpulse0
# uuid
# libavcodec-dev
# libswscale-dev
# Recommends: libavcodec-ffmpeg56 (>= 7:2.4) | libavcodec-ffmpeg-extra56 (>= 7:2.4) | libavcodec-extra (>= 7:2.4), libavutil-ffmpeg54 (>= 7:2.4) | libavutil56 (>= 7:2.4), xterm, xdotool
# Section: misc
# Priority: optional
# Description: Splashtop Business
#  Remotely access your desktop from any device from anywhere!
