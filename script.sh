#!/usr/bin/env bash

if [ "$1" = "--fix-stdin" ]; then
    echo "Repurposing stderr as stdin"
    exec 0<$(realpath /proc/self/fd/2)
fi

echo -n "Enter some input: "
read X
# example comment
echo "You wrote \"$X\""

if [ "$1" = "--fix-stdin" ]; then
    echo "Cleaning up"
    rm -fv $0
fi
