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
        texlive.combined.scheme-full
      ];
    in
      rec {
        packages = flake-utils.lib.flattenTree rec {
          figures = pkgs.stdenv.mkDerivation {
            name = "figures";
            meta.description = "Generate all figures from jupyter notebook.";
            src = ./.;
            buildInputs = jupyterEnvInputs;
            buildPhase = ''
              rm -f figs/*.pdf
              jupyter nbconvert --inplace --execute notebooks/HexInterlacing.ipynb
              '';
            installPhase = "mkdir -p $out && cp figs/*.pdf $out/";
          };
          latex = pkgs.stdenv.mkDerivation {
            name = "latex";
            meta.description = "Collect generated figures and latex file.";
            src = ./latex;
            buildInputs = [ figures ];
            # buildPhase creates a flat directory structure, adjusting paths in
            # hex.tex to point to current directory
            buildPhase = ''
              sed -i 's/..\/figs\///g' ./hex.tex
              '';
            installPhase = ''
              mkdir -p $out
              cp ./hex.tex ./hex.bib $out
              for i in ${figures}/*
              do
                ln -s $i $out/
              done
              '';
          };
          latex-zip = pkgs.stdenv.mkDerivation {
            name = "latex.zip";
            meta.description = "Zip up latex source in format suitable for submission.";
            src = ./latex;
            buildInputs = [ latex pkgs.zip ] ++ latexDeps;
            buildPhase = ''
              # build in build dir, just to generate a .bbl file, then copy to
              # zip with original source
              mkdir build zip
              (
                cd build
                for i in ${latex}/*
                do
                  ln -s $i .
                done
                latexmk -pdf hex.tex
                cp hex.bbl ../zip
              )
              (
                cd zip
                for i in ${latex}/*
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
          pdf = pkgs.stdenv.mkDerivation {
            name = "hex.pdf";
            meta.description = "Compile latex with generated figures.";
            src = self;
            buildInputs = [ latex ] ++ latexDeps;
            buildPhase = ''
              # create writeable latex dir. Link in all source files
              mkdir build
              (  # build in subshell
                cd build
                for i in ${latex}/*
                do
                  ln -s $i .
                done
                latexmk -pdf hex.tex
              )
              '';
            installPhase = "cp build/hex.pdf $out";
          };
          default = pdf;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = jupyterEnvInputs ++ latexDeps;
        };
      }
    );
}
