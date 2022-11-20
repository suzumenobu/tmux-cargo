#!/usr/bin/env bash

commands=`echo "build check clean doc new init add run test select_test bench update publish" | tr ' ' '\n'`
selected=`printf "$commands" | fzf`

# Go to crate root
cd $1

# Exit if nothing selected
if [[ -z $selected ]]; then
    exit

# Search crates
elif [ $selected = "search" ]; then
    read -p "Search: " query
    cargo $selected $query

# Install binary
elif [ $selected = "install" ]; then
    read -p "Install: " query
    cargo $selected $query

# Create new crate
elif [ $selected = "new" ]; then
    read -p "New: " query
    cargo $selected $query

# Add dependency
elif [ $selected = "add" ]; then
    read -p "Add: " query
    cargo $selected $query

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

# Run all tests and enter copy mode
elif [ $selected = "test" ]; then
    cargo $selected
    tmux copy

# Read custom command
elif [ $selected = "custom" ]; then
    read -p "Enter cargo arguments: " query
    cargo $query

# Just run selected command
else
    cargo $selected
fi

echo
echo "COMPLETE"

# Prevent window to close
read

