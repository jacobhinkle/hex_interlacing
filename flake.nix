{
  description = "Source code for 'Hexagonal Scan Interlacing' paper";

  outputs = { self, nixpkgs }: {
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
  };
}
