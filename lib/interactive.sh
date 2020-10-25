#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# Setting options interactively
#############################################################


accepted() {
  [ -z "$1" ] || [ "$1" == "y" ] && return 0
  return 1 
}

accept() {
  echoc 0 PURPLE "$* ? (y/n)"
  read answer

  accepted "$answer" && return 0

  return 1
}

i_menu() {
  accept "Stop on error"  && CONTINUE=false
  accept "Output only errors" && TEST=false
  accept "Output to stdout" && OUTPUT="/dev/stdout"
}


