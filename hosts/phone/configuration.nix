{
  mobile-config,
  nix-config,
  lib,
  ...
}:

let
  inherit (builtins) attrValues;
in
{
  imports = attrValues mobile-config.nixosModules ++ attrValues nix-config.nixosModules;

  nixpkgs = {
    overlays = attrValues nix-config.overlays;

    config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];
  };

  home-manager.sharedModules =
    attrValues mobile-config.homeModules
    ++ (with nix-config.homeModules; [
      eza
      fish
      git
      gpg
      gtk
      htop
      kitty
      librewolf
      neovim
      starship
      xdg-user-dirs
      xresources
    ]);

  hardware.graphics.enable32Bit = lib.mkForce false;

  modules = {
    system = {
      hostName = "mobile-nixos";
      stateVersion = "23.11";
      mullvad = true;
    };

    hardware.keyboardBinds = true;
  };

}
