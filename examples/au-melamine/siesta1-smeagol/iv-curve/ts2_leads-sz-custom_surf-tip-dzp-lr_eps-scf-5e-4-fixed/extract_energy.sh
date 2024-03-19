#!/bin/bash

rm energy.out

 grep 'siesta: E_KS(eV) =          ' log_IV.out | awk '{print $4}'
 grep 'siesta: E_KS(eV) =          ' log_IV.out | awk '{print $4}' >> energy.out
