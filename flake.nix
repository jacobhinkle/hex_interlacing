{
  description = "A very basic flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };

  outputs = { self, nixpkgs, flake-utils }: {
      packages.x86_64-linux.default =
        with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation {
          name = "hexpdf";
          src = self;
          buildInputs = with pkgs; [
            texlive.combined.scheme-full
          ] ++ (with pkgs.python3Packages; [
            jupyter
            matplotlib
            numpy
            ipympl
          ]);
          buildPhase = ''
            jupyter nbconvert --inplace --execute notebooks/HexInterlacing.ipynb
            cd latex
            latexmk -pdf hex.tex
            cd ..
            '';
          installPhase = "mkdir -p $out && cp latex/hex.pdf $out/";
        };
      #devShells = { default=import ./shell.nix {inherit pkgs;}; };
    #);
    #flake-utils.lib.simpleFlake {
      #inherit self nixpkgs;
      #name = "Hexagonal scan interlacing paper";
      #shell = ./shell.nix;
      #systems = [ "x86_64-linux" ];
    #};
  };
}
