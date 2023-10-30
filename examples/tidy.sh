#!/bin/bash

find . -name "*.bak-*" -type f -delete
find . -name "*.wfn*" -type f -delete
find . -name "*.kp*" -type f -delete
find . -name "*.cube*" -type f -delete
find . -name "*.DAT*" -type f -delete
find . -name "*.DM*" -type f -delete
find . -name "*.HST*" -type f -delete
find . -name "*.EDM*" -type f -delete
find . -name "*core*" -type f -delete
find . -name "fort.**" -type f -delete
