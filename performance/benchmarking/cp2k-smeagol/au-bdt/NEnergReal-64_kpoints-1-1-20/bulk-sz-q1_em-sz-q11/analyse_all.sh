#!/bin/bash

for folder in atoms-*/; do
        echo $folder
	cd $folder
	./analyse.sh
	cd ..
done
