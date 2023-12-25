+++
title = "Samples"
paginate_by = 5
sort_by = "none"
+++

A Rosetta stone for modern typesetting engines.

Compare and contrast the approaches taken to the same problems by different typesetting engines.
Sometimes similar input wil be handled differently.
Sometimes different inputs can achieve the same results.
Some engines are more suited to tackling specific problems that others.

Example's welcome, including for a single engine.
Adding additional engines or even alternative examples from the same engile is also welcome

Submit contributions via PR to the GitHub project.

## Local Development

This site statically compiles the examples remotely in CI, but you can achieve the same results locally too.
The only thing required to build the samples in this repository locally is a working `nix` installation (not the OS, just the package manager).
Once you have a working `nix` executable, building the examples can be done with:

```console
$ nix-shell --pure --run 'make all'
```

Generating the static website sources can be done with:

```console
$ nix-shell --pure --run 'make public'
```
