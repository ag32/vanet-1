#!/bin/sh
opp_makemake -f -o manet_dsr -O out -L${VEINSHOME}/out/gcc-debug/src/base -L${VEINSHOME}/out/gcc-debug/src/modules -lmiximbase -lmiximmodules
make
