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
    if [[ -z $query ]]; then
        exit
    else
        cargo $selected $query
    fi

# Install binary
elif [ $selected = "install" ]; then
    read -p "Install: " query
    if [[ -z $query ]]; then
        exit
    else
        cargo $selected $query
    fi

# Create new crate
elif [ $selected = "new" ]; then
    read -p "New: " query
    if [[ -z $query ]]; then
        exit
    else
        cargo $selected $query
    fi

# Add dependency
elif [ $selected = "add" ]; then
    read -p "Add: " query
    if [[ -z $query ]]; then
        exit
    else
        cargo $selected $query
    fi

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
    if [[ -z $query ]]; then
        exit
    else
        cargo $selected $query
    fi

# Just run selected command
else
    cargo $selected
fi

echo
echo "COMPLETE"

# Prevent window to close
read

