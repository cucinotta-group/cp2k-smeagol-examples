#!/bin/bash

#for folder in */; do
for folder in kpoints*/; do
    echo $folder
	cd $folder
	cp ../plot_smeagol-agr.sh .
	./plot_smeagol-agr.sh
	cd ..
done
