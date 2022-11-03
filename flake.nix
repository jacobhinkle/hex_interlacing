{
  description = "Source code for 'Hexagonal Scan Interlacing' paper";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      jupyterEnvInputs = with pkgs.python3Packages; [
        jupyter
        matplotlib
        numpy
        ipympl
      ];
    in
      rec {
        packages = flake-utils.lib.flattenTree rec {
          hex-paper-figures = pkgs.stdenv.mkDerivation {
            name = "hex-paper-figures";
            meta.description = "Generate all figures from jupyter notebook.";
            src = ./.;
            buildInputs = jupyterEnvInputs;
            buildPhase = ''
              jupyter nbconvert --inplace --execute notebooks/HexInterlacing.ipynb
              '';
            installPhase = "mkdir -p $out && cp figs/*.pdf $out/";
          };
          hex-paper-latex = pkgs.stdenv.mkDerivation {
            name = "hex-paper-latex";
            meta.description = "Collect generated figures and latex file.";
            src = ./latex;
            buildInputs = [ hex-paper-figures ];
            installPhase = ''
              mkdir -p $out/latex
              cp ./hex.tex ./hex.bib $out/latex
              ln -s ${hex-paper-figures} $out/figs
              '';
          };
          hex-paper-latex-zip = pkgs.stdenv.mkDerivation {
            name = "hex-paper-latex.zip";
            meta.description = "Zip up latex source in format suitable for submission.";
            src = ./latex;
            buildInputs = [
              hex-paper-latex
              pkgs.zip
            ];
            buildPhase = ''
              tmpout=hex-paper-latex  # directory name once unzipped
              ln -s ${hex-paper-latex} ./$tmpout
              zip -r hex-paper-latex.zip $tmpout
              '';
            installPhase = ''
              cp hex-paper-latex.zip $out
              '';
          };
          hexpdf = pkgs.stdenv.mkDerivation {
            name = "hex.pdf";
            meta.description = "Compile latex with generated figures.";
            src = self;
            buildInputs = with pkgs; [
              hex-paper-latex
              (texlive.combine { inherit (texlive) scheme-medium
              preprint  # for authblk.sty
              latexmk; })
            ];
            buildPhase = ''
              # create writeable latex dir. Link in all source files
              mkdir -p build/latex
              ln -s ${hex-paper-latex}/figs build/figs
              (  # build in subshell
                cd build/latex
                for i in ${hex-paper-latex}/latex/*
                do
                  ln -s $i
                done
                latexmk -pdf hex.tex
              )
              '';
            installPhase = "cp build/latex/hex.pdf $out";
          };
        };
        defaultPackage = packages.hexpdf;
        #apps.jupyter = jupyter
        #defaultApp = jupyter;
      }
    );
}
