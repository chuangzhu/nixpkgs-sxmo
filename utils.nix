{ lib
, stdenv
, fetchFromSourcehut
, gnugrep
, gojq
, busybox
, util-linux
, makeWrapper
, lisgd
, pn
, inotify-tools
, libnotify
, light
, superd
, file
, isX ? false
, sway, dwm
, bemenu, dmenu
, foot, st
, wvkbd, svkbd
, proycon-wayout, conky
, wtype, xdotool
, mako, dunst
, wob
, swayidle, xprintidle
}:

stdenv.mkDerivation rec {
  pname = "sxmo-utils";
  version = "1.11.1";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = pname;
    rev = version;
    hash = "sha256-uV5+erJCe7JmJhKnJF5IQ2kBX6WNxYJRXLo7MBkE0fk=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace '"$(PREFIX)/bin/{}"' '"$(out)/bin/{}"'
    substituteInPlace Makefile --replace '$(DESTDIR)/usr' '$(out)'

    # Nixpkgs' busybox does not include rfkill applet
    substituteInPlace scripts/core/sxmo_common.sh --replace 'alias rfkill="busybox rfkill"' '#'

    # A better way than wrapping hundreds of shell scripts (some of which are even meant to be sourced)
    sed -i '2i export PATH="'"$out"'/bin:${lib.makeBinPath ([
      gojq
      util-linux # setsid, rfkill
      busybox
      lisgd
      pn
      # mnc
      # bonsai
      inotify-tools
      libnotify
      light
      superd
      file
    ] ++ lib.optionals (!isX) [
      (sway.override {
        withBaseWrapper = true;
        withGtkWrapper = true;
      })
      bemenu
      foot
      wvkbd
      proycon-wayout
      wtype
      mako
      wob
      swayidle
    ] ++ lib.optionals isX [
      dwm
      dmenu
      st
      svkbd
      conky
      xdotool
      dunst
      xprintidle
    ])}''${PATH:+:}$PATH"' scripts/core/sxmo_common.sh
    sed -i '3i export XDG_DATA_DIRS="'"$out"'/share''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS"' scripts/core/sxmo_common.sh

    substituteInPlace $(${gnugrep}/bin/grep -rl '\. sxmo_common.sh') \
      --replace ". sxmo_common.sh" ". $out/bin/sxmo_common.sh"
    substituteInPlace \
      scripts/core/sxmo_winit.sh \
      scripts/core/sxmo_xinit.sh \
      scripts/core/sxmo_rtcwake.sh \
      scripts/core/sxmo_migrate.sh \
      --replace "/etc/profile.d/sxmo_init.sh" "$out/etc/profile.d/sxmo_init.sh"

    substituteInPlace scripts/core/sxmo_version.sh --replace "/usr/bin/" ""
    substituteInPlace configs/superd/services/* --replace "/usr/bin/" ""
    substituteInPlace configs/appcfg/sway_template --replace "/usr" "$out"
    substituteInPlace configs/udev/90-sxmo.rules --replace "/bin" "${busybox}/bin"
    substituteInPlace configs/default_hooks/sxmo_hook_desktop_widget.sh --replace "wayout" "proycon-wayout"
  '';

  buildInputs = [ busybox ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "OPENRC=0"
  ];

  meta = with lib; {
    description = "Scripts and small C programs that make the sxmo environment";
    homepage = "https://sxmo.org";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
