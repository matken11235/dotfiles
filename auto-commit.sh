#!/bin/bash

cd $(dirname $0)

git pull origin master
DIFF=$(git --no-optional-locks status)
if [[ $DIFF -ne *"files"* ]]; then
    :
else
    git add -A .
    git commit -m ":sparkles: Auto update by launchd"
    git push origin master
fi

\rm -rf /cores
