final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (super: {
    patches = super.patches ++ [
      (prev.fetchpatch {
        url = "https://github.com/swaywm/sway/pull/6455/commits/07360dba2aed979f1d3c68d8f456d748343d6809.patch";
        hash = "sha256-H9QaCKkzFMg/IPX8tdywQYHOjr7y99GQ0rTtXAN0av0=";
      })
    ];
  });

  sxmo-utils = prev.callPackage ./utils.nix { };
}
