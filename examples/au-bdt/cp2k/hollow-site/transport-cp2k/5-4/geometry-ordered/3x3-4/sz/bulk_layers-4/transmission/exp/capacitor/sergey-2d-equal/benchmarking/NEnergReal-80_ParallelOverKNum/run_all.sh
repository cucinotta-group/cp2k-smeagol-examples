#! /bin/bash

for folder in */ ; do
        echo "$folder"
        cd $folder
        ./analyse.sh
        cd ..
done
