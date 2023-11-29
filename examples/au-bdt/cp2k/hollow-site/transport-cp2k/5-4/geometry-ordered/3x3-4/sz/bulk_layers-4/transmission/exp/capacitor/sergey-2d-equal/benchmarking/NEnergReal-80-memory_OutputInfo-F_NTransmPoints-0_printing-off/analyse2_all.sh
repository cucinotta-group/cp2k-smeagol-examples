#! /bin/bash

for folder in */ ; do
        echo "$folder"
        cd $folder
        ./analyse2.sh
        cd ..
done
