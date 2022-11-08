final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (super: {
    src = prev.fetchFromSourcehut {
      owner = "~stacyharper";
      repo = "sway";
      rev = "1.7.0";
      hash = "sha256-8531iiXJpPdwQBDZW5tH5sd3XB9vkPS0XHho0YhKREw=";
    };
  });

  sxmo-utils = prev.callPackage ./utils.nix { };
  superd = prev.callPackage ./superd.nix { };
}
