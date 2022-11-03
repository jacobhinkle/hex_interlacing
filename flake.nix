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
      latexDeps = with pkgs; [
        (
          texlive.combine {
            inherit (texlive)
            scheme-medium
            preprint  # for authblk.sty
            latexmk; }
        )
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
            # buildPhase creates a flat directory structure, adjusting paths in
            # hex.tex to point to current directory
            buildPhase = ''
              sed -i 's/..\/figs\///g' ./hex.tex
              '';
            installPhase = ''
              mkdir -p $out
              cp ./hex.tex ./hex.bib $out
              for i in ${hex-paper-figures}/*
              do
                ln -s $i $out/
              done
              '';
          };
          hex-paper-latex-zip = pkgs.stdenv.mkDerivation {
            name = "hex-paper-latex.zip";
            meta.description = "Zip up latex source in format suitable for submission.";
            src = ./latex;
            buildInputs = [ hex-paper-latex pkgs.zip ] ++ latexDeps;
            buildPhase = ''
              # build in build dir, just to generate a .bbl file, then copy to
              # zip with original source
              mkdir build zip
              (
                cd build
                for i in ${hex-paper-latex}/*
                do
                  ln -s $i .
                done
                latexmk -pdf hex.tex
                cp hex.bbl ../zip
              )
              (
                cd zip
                for i in ${hex-paper-latex}/*
                do
                  ln -s $i .
                done
                zip -r ../hex-paper-latex.zip *
              )
              '';
            installPhase = ''
              cp hex-paper-latex.zip $out
              '';
          };
          hexpdf = pkgs.stdenv.mkDerivation {
            name = "hex.pdf";
            meta.description = "Compile latex with generated figures.";
            src = self;
            buildInputs = [ hex-paper-latex ] ++ latexDeps;
            buildPhase = ''
              # create writeable latex dir. Link in all source files
              mkdir build
              (  # build in subshell
                cd build
                for i in ${hex-paper-latex}/*
                do
                  ln -s $i .
                done
                latexmk -pdf hex.tex
              )
              '';
            installPhase = "cp build/hex.pdf $out";
          };
        };
        defaultPackage = packages.hexpdf;
        #apps.jupyter = jupyter
        #defaultApp = jupyter;
      }
    );
}
