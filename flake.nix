{
  inputs = {
    nix-config.url = "github:donovanglover/nix-config";

    mobile-nixos = {
      url = "github:donovanglover/mobile-nixos";
      inputs.nixpkgs.follows = "nix-config/nixpkgs";
    };
  };

  outputs =
    { self, nix-config, mobile-nixos }@attrs:
    let
      inherit (nix-config.inputs) nixpkgs;
      inherit (builtins) attrValues;

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

      nixosConfigurations = {
        mobile-nixos = nixosSystem {
          system = "aarch64-linux";

          specialArgs = attrs // {
            mobile-config = self;
          };

          modules = listFilesRecursive ./hosts/phone ++ attrValues mobile-nixos.nixosModules ++ [
            {
              mobile.beautification = {
                silentBoot = true;
                splash = true;
              };
            }
          ];
        };

        mobile-nixos-vm = nixosSystem {
          system = "x86_64-linux";

          specialArgs = attrs // {
            mobile-config = self;
          };

          modules = listFilesRecursive ./hosts/phone;
        };
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
