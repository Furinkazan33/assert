#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# Setting options interactively
#############################################################


echoc 0 PURPLE "Stop on error ? (y/n)"
read answer
[ "$answer" == "y" ] && CONTINUE=false

echoc 0 PURPLE "Output only errors ? (y/n)"
read answer
[ "$answer" == "y" ] && TEST=false

echoc 0 PURPLE "Output to stdout ? (y/n)"
read answer
[ "$answer" == "y" ] && OUTPUT="/dev/stdout"

