#! /bin/bash

cp ../downloaded/* .
find . -name "*.gz" | xargs gunzip
rm *.gz
