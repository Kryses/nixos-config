final: prev: {
  herbstluftwm = prev.herbstluftwm.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      # Add missing include for uint8_t
      if ! grep -qE '^\s*#include <cstdint>\s*$' src/xconnection.cpp; then
        sed -i 's|^#include "globals\.h"$|#include "globals.h"\n#include <cstdint>|' src/xconnection.cpp
      fi
    '';

    # Tests are flaky/hanging in Nix sandbox (SIGTERM handling)
    doCheck = false;
  });

  # optional safety if something pulls pkgs.xorg.herbstluftwm
  xorg = prev.xorg // {
    herbstluftwm = prev.xorg.herbstluftwm.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        if ! grep -qE '^\s*#include <cstdint>\s*$' src/xconnection.cpp; then
          sed -i 's|^#include "globals\.h"$|#include "globals.h"\n#include <cstdint>|' src/xconnection.cpp
        fi
      '';
      doCheck = false;
    });
  };
}
