# [Polytype](https://alerque.github.io/polytype)

A Rosetta stone for typesetting engines.


This project's goal is to provide a chrestomathy for typesetting similar to what [Rosetta Code][rosettacode] does for programming languages.
The samples here are designed to compare and/or contrast the approaches taken to various typesetting situations by different typesetting engines.
 
The emphasis is less on document markup languages, programming languages, or actual content and more on the way layout and orthographic features are achieved.
Sometimes similar input will produce very different outputs.
Sometimes similar output is achieved with very different inputs.
Some engines are more suited to tackling specific problems that others.

## Contributions

New samples are always welcome, including for any single engine.
Adding support for current samples in additional engines is also welcome.
Improvements to the current samples may be considered if they are more idiomatic or useful as examples.
Alternative samples from the current engines may also be considered if they demonstrate some contrast or similarity with a different engine.

Contributions may be submitted as as pull requests to the [GitHub project][gh].

## Local development

All input samples are rendered remotely in CI and used to create the static site.
Contributions may be made just by editing or adding input samples.

If you do want to test render them locally you can build the site just like it is done in CI.

The only thing required to build the samples in this repository locally is a working `nix` installation (not the OS, just the package manager).
Once you have a working `nix` executable, building the examples can be done with:

```console
$ nix-shell --pure --run 'make all'
```

To generate the static version of the website and serve it locally for testing, try:

```console
$ nix-shell --pure --run 'make serve'
```

This will print out a localhost address for you to browse to and stay running serving the current version of the site.
Some resources will automatically update and refresh while the sever is running.
For the rendered examples running `make all` in another terminal should update the images and the site will refresh.

  [gh]: https://github.com/alerque/polytype
  [rosettacode]: https://rosettacode.org/wiki/Rosetta_Code
