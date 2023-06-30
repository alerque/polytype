# [Polytype](https://alerque.github.io/polytype)

A Rosetta stone for modern typesetting engines.

## Development

The only thing required to build the samples in this repository locally is a working `nix` installation (not the OS, just the package manager).
Once you have a working `nix` executable, building the examples can be done with:

```console
$ nix-shell --pure --run 'make all'
```

Generating the static website sources can be done with:

```console
$ nix-shell --pure --run 'make public'
```
