#!/bin/sh
opp_makemake -f -o veins -O out -L${VEINSHOME}/out/gcc-debug/src/base -L${VEINSHOME}/out/gcc-debug/src/modules -lmiximbase -lmiximmodules
make
