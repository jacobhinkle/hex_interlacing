# Python and LaTeX for "Hexagonal Scan Interlacing"

The code for this paper is found entirely in the
`notebooks/HexInterlacing.ipynb` jupyter notebook. The requirements are minimal
(jupyter, numpy, matplotlib, and ipympl only if you would like interactive
plots).

The document is written in latex and resides in `latex/hex.tex` along with the
bibliography `latex/hex.bib`. I typically compile this manually using `latexmk
-pdf hex.tex`.

## Using the Nix flake

If you have a working install of the [nix package manager]() with [nix flakes enabled](https://nixos.wiki/wiki/Flakes), you can use this repository like any other Nix flake; i.e. by using `nix build` or `nix run`.  The command `nix flake show` will display all possible targets you can build: for example you can build all the figures, a full latex directory, or a zip-file suitable for upload to the arxiv.

In fact, since we are using nix flakes, you can build the PDF without even
manually cloning this repository using the following command (once this
repository is made public):
```
nix build github:jacobhinkle/hex_interlacing
```
The command above will build all figures and the final PDF. The result will be
placed in a symlink named `result` that points to a PDF in your nix store. To
rebuild the paper and view it without creating the `result` symlink, you can
run something like:
```
zathura $(nix build --no-link --print-out-paths github:jacobhinkle/hex_interlacing#hexpdf)
```

If you would like to interact with the notebook, clone this repository then you
can acquire a dev shell using `nix develop` then run `jupyter notebook`.
