#!/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/utils

bash_intents() {
    local text="$@"
    local intent_file=
    local result=
    local intent=
    local intent_regex=
    local intent_handler=
    # You can specify the intents directory using the BASH_INTENTS_DIR env variable
    local intents_dir=${BASH_INTENTS_DIR:-$SCRIPT_DIR/intents}

    # enable case insensitive matching
    shopt -s nocasematch 

    # remove any interpunction from the text
    text=$(echo "$text" | sed -e 's/[[:punct:]]//g')

    # Processes each intent_file in the ./intents directory
    # Each intent_file will contain an array of regex rules
    # If the text matches the regex, run the action
    # The action is defined in the intent_handler function
    # in the same intent_file
    for intent_file in $(find ${intents_dir} -type f); do
        intent=$(basename "$intent_file")
        intent_regex=()
        intent_handler=""

        # $intent_file should define $intent_regex and $intent_handler
        source "$intent_file"

        # check if intent_handler function is defined
        if [ "$(type -t intent_handler)" != function ]; then
            die "Intent $intent_file must define the intent_handler() function."
        fi

        # check the length of the intent_regex array
        if [ ${#intent_regex[@]} -eq 0 ]; then
            die "Intent $intent_file must define the intent_regex array."
        fi

        # try to match the text against each regex rule
        for regex in "${intent_regex[@]}"; do
            eval_string=$(match_text_with_regex "$text" "$regex")
            if [ $? -ne 0 ]; then
                continue
            fi

            logger debug "Running $intent.intent_handler with"
            logger debug "$matched_array_as_a_string"
            intent_handler "$text" "$eval_string"
            exit 0
        done
    done

    echo "No intent matched for $text" 1>&2
}

# If the script is not sourced, run the bash_intents function
# with the arguments passed to the script
if [ "$0" = "$BASH_SOURCE" ]; then
    bash_intents "$@"
fi
