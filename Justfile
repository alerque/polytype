just := just_executable()
nix := require('nix')
zsh := require('zsh')

set script-interpreter := ['nix', 'develop', '--ignore-environment', '--command', 'zsh', '+o', 'nomatch', '-feu']
set shell := ['zsh', '+o', 'nomatch', '-fecu']

set default-list
set default-script
set positional-arguments
set unstable

# With positional arguments enabled, we can pass all the arguments to the bash
# shell in a way that will get expanded to the original 'word' breakdown. However,
# when we do this blindly in all cases and the job's positional arguments happen
# to be empty the shell decides we must have wanted a placeholder for an empty
# string argument — a construct that is invalid for many of our commands. The
# solution is to decide up front whether we have any positional arguments at all
# and then either not pass anything or pass them in a way that will get expanded
# properly. As a caveat we can't use this workaround for nested jobs that pass
# positional arguments to other jobs since one layer of quoting is lost, but we
# don't need to because none of those happen to use spaces in arguments anyway.
maybe-pass(args) := if args != "" { '"$@"' } else { "" }

# Build everything needed to serve the site
build:
    make public

# Run any arbitrary make command in the nix development environment
make *ARGS:
    make {{ maybe-pass(ARGS) }}

# Build the site and also serve it on a localhost port for review
preview:
    (
        while ! nc -z localhost 1111; do sleep 1; done
        xdg-open http://localhost:1111
    )&
    make serve
