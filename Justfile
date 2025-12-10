just := just_executable()
nix := require('nix')
zsh := require('zsh')

set script-interpreter := ['nix', 'develop', '--command', 'zsh', '+o', 'nomatch', '-eu']
set shell := ['zsh', '+o', 'nomatch', '-ecu']
set unstable := true

[default]
[private]
@list:
    {{ just }} --list --unsorted

[script]
build:
    make public

[script]
preview:
    (
        while ! nc -z localhost 1111; do sleep 1; done
        xdg-open http://localhost:1111
    )&
    make serve
