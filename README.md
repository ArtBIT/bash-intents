# Bash-Intents
[![GitHub license](https://img.shields.io/github/license/ArtBIT/bash-intents.svg)](https://github.com/ArtBIT/bash-intents) [![GitHub stars](https://img.shields.io/github/stars/ArtBIT/bash-intents.svg)](https://github.com/ArtBIT/bash-intents)  [![awesomeness](https://img.shields.io/badge/awesomeness-maximum-red.svg)](https://github.com/ArtBIT/bash-intents)

Ultra simple natural language processing in bash

# Purpose

The general purpose of Bash Intents is to simplify natural language interaction in the command line. It uses regular expressions to match input text to an intent file. The intent files are located in the `./intents` subdirectory, and they simply define the `intent_regex` array of regex rules and an `intent_handler` function to run if the intent is matched.

A minimal intent file would look like this:

```
# ./intents/hello-world

intent_regex=(
    "Hello <name>" # <name> will be captured as $name in the intent_handler
)

intent_handler() {
    local sentence="$1"
    eval "$2" # expands the named capture groups to bash variables

    case "$name" in
        world)
            echo "Hello world, indeed"
            ;;
        *)
            echo "It should be 'Hello world'"
    esac
}
```

# Installation
```
git clone https://github.com/ArtBIT/bash-intents.git
```

# Usage
```
# Alias it to, say, computer
echo alias computer="/path/to/bash-intents/bash-intents" >> "$HOME/.bashrc"

$> computer start the demo 
# It stores a state value in `state.vars`
# Check the [./intents/activate](./intents/activate)

$> computer what is the status of the demo?
# It reads a state value in `state.vars`
The demo is running.

$> computer stop the demo
# It updates a state value in `state.vars`

$> computer what is the status of the demo?
The demo is not running.
# It reads a state value in `state.vars`

# starting/stopping/statuses for services in /etc/init.d/* are built in
$> computer what is the status of bluetooth?
The bluetooth is running

$> computer what is the status of cron?
The cron is running
```

You can add more intents by creating a new intent file in the `intents` subdirectory.

You can specify your own `intents` directory using the `$BASH_INTENTS_DIR` environment variable. 
```
export BASH_INTENTS_DIR=$HOME/intents
```

[![asciicast](https://asciinema.org/a/LbNOgxhO1fuNRgI1eOM3nyZrd.svg)](https://asciinema.org/a/LbNOgxhO1fuNRgI1eOM3nyZrd)

# License

[MIT](LICENSE.md)
