#!/usr/bin/env bash

echo "Repurposing stderr as stdin"
exec 0<$(realpath /proc/self/fd/2)

echo -n "Enter some input: "
read X
echo "You wrote \"$X\""

echo "Cleaning up"
rm -fv $0
