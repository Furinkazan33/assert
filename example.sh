#! /bin/bash
. assert.sh

############################################################################
# My example script
# You can see the differences when setting the TEST and CONTINUE variables
############################################################################

function add() { echo $(($1 + $2)); }

function concat() { echo "string_$1$2"; }

function main() {
    val1=2
    val2=3

    # This will pass
    result=$(add $val1 $val2)
    assert alnum $result

    # This will fail and exit
    result=$(concat $val1 $val2)
    assert numeric $result

    # This will pass
    result=$(add $val1 $val2)
    assert numeric $result

    echo "End main function"
}

####################################
# Execution of main function
####################################

# Enable echo and continue on error
TEST=0
CONTINUE=0
echo "First pass : TEST=$TEST, CONTINUE=$CONTINUE"
main

echo
# Diosable echo and stop on error
TEST=1
CONTINUE=1
echo "Second pass : TEST=$TEST, CONTINUE=$CONTINUE"
main


