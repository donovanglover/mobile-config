{ nixosConfig, pkgs, ... }:

let
  inherit (nixosConfig._module.specialArgs) mobile-config;

  inherit (mobile-config.packages.${pkgs.system}) mobile-config-firefox;
in
{
  home.file = {
    ".librewolf/default/chrome/userChrome.css".source = "${mobile-config-firefox}/userChrome.css";
    ".librewolf/default/chrome/userContent.css".source = "${mobile-config-firefox}/userContent.css";
  };
}
