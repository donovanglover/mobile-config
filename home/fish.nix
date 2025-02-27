{ lib, ... }:

{
  programs.fish = {
    enable = true;

    loginShellInit = lib.mkForce # fish
      ''
        if test (tty) = /dev/tty1
          exec phosh-session
        end
      '';
  };
}
