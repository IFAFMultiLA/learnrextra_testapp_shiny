#!/bin/sh
# depwatcher.sh <command> <dir>
#
# Shell script to watch a dependency directory <dir> for changes and restart <command> in that event.
#
# Taken and adapted from https://stackoverflow.com/a/34672970.
#

sigint_handler()
{
  kill $PID
  exit
}

trap sigint_handler SIGINT

while true; do
  echo "starting $1"
  $1 &
  PID=$!
  echo "watching $2"
  inotifywait -e modify -e move -e create -e delete -r "$2" @"$2/.Rproj.user/"
  kill $PID
done

