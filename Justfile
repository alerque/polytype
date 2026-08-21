just := just_executable()
nix := require('nix')
zsh := require('zsh')

set script-interpreter := ['nix', 'develop', '--command', 'zsh', '+o', 'nomatch', '-eu']
set shell := ['zsh', '+o', 'nomatch', '-ecu']

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
