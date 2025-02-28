{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.modules.system) username hashedPassword;
  inherit (config.boot) isContainer;
in
{
  config = {
    environment = {
      systemPackages = with pkgs; [
        chatty
        megapixels
        livi
        gnome-contacts
        eog
        alacritty
      ];
    };

    users.users.${username}.password = lib.mkIf (hashedPassword == null && !isContainer) "1234";

    home-manager = {
      sharedModules = lib.singleton {
        programs.man.generateCaches = lib.mkForce false;
      };
    };

    programs = {
      calls.enable = true;
      hyprland.enable = lib.mkForce false;
      cdemu.enable = lib.mkForce false;
      thunar.enable = lib.mkForce false;
    };

    i18n.inputMethod.enable = lib.mkForce false;

    networking = {
      wireless.enable = false;
      wireguard.enable = true;

      networkmanager.ensureProfiles.profiles = {
        mobile = {
          connection = {
            id = "4G";
            type = "gsm";
          };

          gsm.apn = "NXTGENPHONE";
          ipv4.method = "auto";

          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
        };
      };

      firewall.checkReversePath = lib.mkForce false;
    };

    documentation = {
      enable = false;
      man.generateCaches = false;
    };

    services = {
      xserver = {
        displayManager.lightdm.enable = false;

        desktopManager.phosh = {
          enable = true;
          group = "users";
          user = username;
        };
      };

      udisks2.enable = lib.mkForce false;
      pipewire.enable = lib.mkForce false;
      greetd.enable = lib.mkForce false;

      getty.autologinUser = username;
    };

    boot = {
      enableContainers = false;

      kernel.sysctl = {
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
      };
    };

    powerManagement = {
      enable = true;

      cpufreq = rec {
        min = 816000;
        max = min;
      };

      cpuFreqGovernor = "performance";
    };
  };
}
