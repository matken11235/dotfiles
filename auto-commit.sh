#!/bin/bash

cd $(dirname $0)

DIFF=$(git status)
if [[ $DIFF -ne *"files"* ]]; then
    :
else
    git add -A .
    git commit -m ":sparkles: Auto update by cron"
    git push origin master
fi

