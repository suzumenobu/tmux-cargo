#!/usr/bin/env bash

commands=`echo "test select_test run clippy build custom help" | tr ' ' '\n'`
selected=`printf "$commands" | fzf`

# Go to crate root
cd $1

# Exit if nothing selected
if [[ -z $selected ]]; then
    exit

# Parse all tests and do fzf
elif [ $selected = "select_test" ]; then
    tests=`cargo test -- --list --format=terse 2> /dev/null | sed 's/: .*//g'`
    test=`printf "$tests" | fzf`

    # Exit if nothing selected
    if [[ -z $test ]]; then
        exit
    else
        cargo test $test
    fi

# Read custom command
elif [ $selected = "custom" ]; then
    read -p "Enter cargo arguments: " query
    cargo $query

# Just run selected command
else
    cargo $selected
fi

# Enter tmux copy mode for scrolling
tmux copy

# Prevent window to close
read

