#!/bin/bash

dir='.'

if [ "$#" -gt 0 ]; then
dir=$1
fi

files_count=$(find $dir -type f | wc -l)

echo "Files count in the directory (including subdirs): $files_count"



