#!/bin/bash

# CP2K
find . -name "*.bak-*" -type f -delete
find . -name "*.wfn*" -type f -delete
find . -name "*.kp*" -type f -delete
find . -name "*.cube*" -type f -delete

# SMEAGOL
find . -name "*RHO*txt*" -type f -delete
find . -name "*VH*txt*" -type f -delete
find . -name "*.DAT*" -type f -delete
find . -name "*.DM*" -type f -delete
find . -name "*.HST*" -type f -delete
find . -name "*.EDM*" -type f -delete
find . -name "*core*" -type f -delete
find . -name "fort.**" -type f -delete
find . -name "*.HS*" -type f -delete
find . -name "*.RHO*" -type f -delete
find . -name "*.LDOS*" -type f -delete
find . -name "*.VH*" -type f -delete


find . -type f -size +100M
#find . -type f -size +100M  -exec zip -m '{}.zip' '{}' \;

