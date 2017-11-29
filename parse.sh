#!/bin/bash

tempDir='./temp';
sortedImages="$tempDir/sorted-images";

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "Text read from file: $line";
    wget $line --recursive --directory-prefix=$tempDir --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" -R jpg,png,giv,svf --html-extension;
done < "$1"

