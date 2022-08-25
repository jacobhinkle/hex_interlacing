{
  description = "A very basic flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = flake-utils.lib.flattenTree {
          #hexpdf = {};
          #hello = pkgs.hello;
          #gitAndTools = pkgs.gitAndTools;
        };
        defaultPackage = packages.hexpdf;
      }
    );
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "Hexagonal scan interlacing paper";
      shell = ./shell.nix;
      systems = [ "x86_64-linux" ];
    };
}
