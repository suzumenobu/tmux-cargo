#!/usr/bin/env bash

commands=`echo "build check clean doc new init add run test select_test bench update publish custom" | tr ' ' '\n'`
selected=`printf "$commands" | fzf`

function read_query() {
    local query_message=$1

    read -p "$query_message: " query

    if [[ -z $query ]]; then
        exit
    fi

    return query
}

# Go to crate root
cd $1

# Exit if nothing selected
if [[ -z $selected ]]; then
    exit

# Search crates
elif [ $selected = "search" ]; then
    query=$(read_query "Search")
    cargo $selected $query

# Install binary
elif [ $selected = "install" ]; then
    query=$(read_query "Install")
    cargo $selected $query

# Create new crate
elif [ $selected = "new" ]; then
    query=$(read_query "New")
    cargo $selected $query

# Add dependency
elif [ $selected = "add" ]; then
    query=$(read_query "Add")
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

# Read custom command
elif [ $selected = "custom" ]; then
    query=$(read_query "Enter cargo arguments")
    cargo $query

# Just run selected command
else
    cargo $selected
fi

echo
echo "COMPLETE"

# Prevent window to close
tmux copy-mode 
tmux send-keys 'k0'
read -n 1 -s


