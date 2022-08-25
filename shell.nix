{ pkgs ? import <nixpkgs> }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    texlive.combined.scheme-full
  ] ++ (with pkgs.python3Packages; [
    jupyter
    matplotlib
    numpy
    ipympl
  ]);
}
