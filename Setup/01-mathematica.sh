#!/bin/bash
# Raise errors if any
set -e
set -x

MATHLM_SERVER=192.168.26.37
# Make the path variable later
INST_DIR=/nfs/.share/Install/Mathematica/
MATH_INSTALLER=Mathematica_13.1.0_LINUX.sh
GRID_INSTALLER=gridMathematica_13.1.0_LightweightGridManager_LINUX.sh
OPTIONS="-- -auto -silent -selinux=y"

# Install license
LIC_DIR=/usr/share/Mathematica/Licensing
mkdir -p $LIC_DIR
echo \!$MATHLM_SERVER > $LIC_DIR/mathpass
# Install Mathematica
$INST_DIR$MATH_INSTALLER $OPTIONS

# Install gridMathematica
$INST_DIR$GRID_INSTALLER $OPTIONS

