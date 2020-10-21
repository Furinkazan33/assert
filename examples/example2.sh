#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# This file shows the differences :
#  - between the test mode and the execution mode
#  - when setting the TEST and CONTINUE variables
#############################################################

# Change this line as your needs
ASSERT_ROOT=$(dirname $0)/..

. $ASSERT_ROOT/assert.sh

# No log file
OUTPUT="/dev/stdout"

# Usage
[ $# -ne 0 ] && { echo "Usage: ./example2.sh"; exit 1; }


function add() {
    echo $(($1 + $2))
}

function concat() { 
    echo "string_$1$2"
}

function main() {
    val1=2
    val2=3
    
    # This will pass
    result=$(add $val1 $val2)
    assert alnum $result
    
    # This will fail
    result=$(concat $val1 $val2)
    assert numeric $result
    
    # This will pass
    result=$(add $val1 $val2)
    assert numeric $result
    
    echo "End main function"
}

####################################
# Tests 
####################################

# Enable echo and continue on error
TEST=true
CONTINUE=true
echo "First pass : TEST=$TEST, CONTINUE=$CONTINUE"
main

echo
# Disable echo and stop on error
TEST=false
CONTINUE=false
echo "Second pass : TEST=$TEST, CONTINUE=$CONTINUE"
main

