{
  stdenv,
  lib,
  fetchgit,
  python310
  # gzip,
  # tar
}:
stdenv.mkDerivation rec {
  pname = "ayon-launcher";
  version = "1.3.4";

  src = fetchgit {
    url = "https://github.com/ynput/ayon-launcher";
    rev = "1.3.4";
    sha256 = "sha256-3btr0J4p8SRPdgqyUk+C5eA0aRwrxzVnvddNjwsyJNc=";
  };

  doCheck = false;
  dontBuild = true;
  buildInputs = [];

  buildPhase = ''
    ${src}/tools/make.sh create-env
    ${src}/tools/make.sh install-runtime-dependencies

  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp -r ${src} $out/lib
    # mkdir -p $out/bin
    # cp -r ${pname}/*/* $out/bin
    # chmod +x $out/bin/ayon
    # chmod +x $out/bin/app_launcher
    # chmod +x $out/bin/ayon_console

  '';

  propagatedBuildInputs = [python310];

  meta = with lib; {
    description = "Ayon Launcher";
    homepage = "https://github.com/ynput/${pname}";
    licenses = licenses.apache;
    platforms = platforms.unix;
  };
}
