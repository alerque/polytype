just := just_executable()
nix := require('nix')
zsh := require('zsh')

set script-interpreter := ['nix', 'develop', '--ignore-environment', '--command', 'zsh', '+o', 'nomatch', '-feu']
set shell := ['zsh', '+o', 'nomatch', '-fecu']

set default-list
set default-script
set unstable

build:
    make public

preview:
    (
        while ! nc -z localhost 1111; do sleep 1; done
        xdg-open http://localhost:1111
    )&
    make serve
