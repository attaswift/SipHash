#!/bin/bash

set -e

cd "$(dirname "${0}")"

if [ $# -ne 1 ]; then
  echo "Usage: $0 <Project name>" >&2
  exit 1
fi

name="$1"
pattern="SipHash"

# Rename files and directories whose names contain the pattern.
while true; do
  source="$(find *  -iname "*$pattern*" | head -1)"
  if [ "$source" == "" ]; then
    break 
  fi
  target=""${source/$pattern/$name}""
  echo "Renaming $source to $target"
  mv "$source" "$target"
done

# Remove xcuserdata stuff; it contains a binary plist that sed chokes on.
rm -rf *.xcodeproj/project.xcworkspace/xcuserdata

# Replace occurances of the pattern in all files.
grep -rl "$pattern" .travis.yml * | while read file; do 
  echo "Updating $file"
  sed -i "" "s/$pattern/$name/g" "$file"
done
