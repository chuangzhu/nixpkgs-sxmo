{ config, pkgs, ... }:

let
  defaultUserName = "alice";
in

{
  imports = [ ./module.nix ];
  nixpkgs.overlays = [ (import ./overlay.nix) ];

  users.users."${defaultUserName}" = {
    isNormalUser = true;
    initialPassword = "1234";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  services.xserver.desktopManager.sxmo = {
    enable = true;
    user = defaultUserName;
    group = "users";
  };

  networking.useDHCP = false;
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Fira Code Nerd Font" ];
    };
  };
}
