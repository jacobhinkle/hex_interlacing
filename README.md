# Code and source for "Hexagonal Scan Interlacing"

The code for this small paper is found entirely in the
`notebooks/HexInterlacing.ipynb` jupyter notebook. The requirements are minimal
(jupyter, numpy, matplotlib, and ipympl only if you would like interactive
plots).

The document is written in latex and resides in `latex/hex.tex` along with the
bibliography `latex/hex.bib`. I typically compile this manually using `latexmk
-pdf hex.tex`.

## Nix/NixOS

If you have a working install of the [nix package manager]() and are on an
`x86_64-linux` system, you can use this repository like any other Nix flake.

To build all figures and the final PDF, you may run `nix build` from this
directory. The result will be placed in `result/hex.pdf` where `result` is a
symlink to your nix store. If you would like to interact with the notebook, you
can acquire a dev shell using `nix develop`.

In fact, since we are using nix flakes, you can build the pdf without even
manually cloning this repository using the following command (once this
repository is made public):
```
nix build github:jacobhinkle/hex_interlacing_paper
```
While the repository remains private (before posting the preprint), you can use
the slightly more verbose:
```
nix build git+ssh://git@github.com/jacobhinkle/hex_interlacing_paper
```
