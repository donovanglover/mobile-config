{
  inputs = {
    nix-config.url = "github:donovanglover/nix-config";

    mobile-nixos = {
      url = "github:donovanglover/mobile-nixos";
      inputs.nixpkgs.follows = "nix-config/nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      inherit (nixpkgs.lib) nixosSystem genAttrs replaceStrings;
      inherit (nixpkgs.lib.filesystem) packagesFromDirectoryRecursive listFilesRecursive;

      forAllSystems =
        function:
        genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      nameOf = path: replaceStrings [ ".nix" ] [ "" ] (baseNameOf (toString path));
    in
    {
      packages = forAllSystems (
        pkgs:
        packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;

          directory = ./packages;
        }
      );

      nixosModules = genAttrs (map nameOf (listFilesRecursive ./modules)) (
        name: import ./modules/${name}.nix
      );

      homeModules = genAttrs (map nameOf (listFilesRecursive ./home)) (name: import ./home/${name}.nix);

      overlays = genAttrs (map nameOf (listFilesRecursive ./overlays)) (
        name: import ./overlays/${name}.nix
      );

      checks = forAllSystems (
        pkgs:
        genAttrs (map nameOf (listFilesRecursive ./tests)) (
          name:
          import ./tests/${name}.nix {
            inherit self pkgs;
          }
        )
      );

      nixosConfigurations = {
        mobile-nixos = nixosSystem {
          system = "aarch64-linux";
          specialArgs.nix-config = self;
          modules = listFilesRecursive ./hosts/phone;
        };

        mobile-nixos-vm = nixosSystem {
          system = "x86_64-linux";
          specialArgs.nix-config = self;
          modules = listFilesRecursive ./hosts/phone;
        };
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
