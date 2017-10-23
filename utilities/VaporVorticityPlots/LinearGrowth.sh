#!/bin/sh

###########################################################################
##
##  Filename       : LinearGrowth.sh
##  Author         : Ryan Moll
##  Date Modified  :
##  Purpose        : Batch script for generating data to plot with vapor
##
###########################################################################


# Allows vapor to run by command line
. /Applications/VAPOR/VAPOR.app/Contents/MacOS/vapor-setup.sh

# Create vdf file with dimensions of 3D data set, performance level(?),
# number of time steps, variable names, vdf file name
vdfcreate -dimension 96x96x96 -level 4 -numts 1 -vars3d omz vorticity10.vdf
vdfcreate -dimension 96x96x96 -level 4 -numts 1 -vars3d omz vorticity100.vdf
vdfcreate -dimension 96x96x96 -level 4 -numts 1 -vars3d omz vorticity1000.vdf

# Write raw data for each timestep into format vapor understands
raw2vdf -ts 0 -varname omz vorticity10.vdf vorticity10.bin
raw2vdf -ts 0 -varname omz vorticity100.vdf vorticity100.bin
raw2vdf -ts 0 -varname omz vorticity1000.vdf vorticity1000.bin

# Run vapor gui
vaporgui vorticity10.vdf
#vaporgui vorticity100.vdf
#vaporgui vorticity1000.vdf
