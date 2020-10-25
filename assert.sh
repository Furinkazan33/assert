#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# assert function to test scripts
# Do the following to use directly in your scripts :
# TEST=false will disable echoes of passed tests
# (optionnal) CONTINUE=false will stop execution on error
#############################################################

LIB=$(dirname "${BASH_SOURCE[0]}")/lib

. $LIB/colors.sh
. $LIB/functions.sh
. $LIB/interactive.sh

# By default, assert is for tests, so do not stop on errors
TEST=true
CONTINUE=true

# Creating logs folder
LOGS="logs"
mkdir $LOGS 2> /dev/null

# Output file, set as "/dev/stdout" to output to stdout
#OUTPUT="/dev/stdout"
OUTPUT="$LOGS/execution_$(date +%Y_%m_%d_%s).log"


_assertion_failed() {
    is_true $TEST && echoc 0 KO "$* => failed" || echoc 0 KO "An assertion failed during the execution of your script ($*)"
    total_failed=$(($total_failed + 1));
    is_false $CONTINUE && { echo "Stopping script (CONTINUE=$CONTINUE)"; exit 1; }
} >> $OUTPUT

_assertion_passed() {
    is_true $TEST && echoc 0 OK "$* => passed"
    total_passed=$(($total_passed + 1))
} >> $OUTPUT

_test() {
    local function=$1
    local params=${*:2}

    $function $params
    
    return $?
}

_assert() {
    _test "$*" || { _assertion_failed "$*"; return 1; }

    _assertion_passed "$*"

    return 0
}

_assert_not() {
    _test "$*" && { _assertion_failed "not $*"; return 1; }

    _assertion_passed not "$*"

    return 0
}

assert() {
  [ "$1" == "help" ] && {
    echoc 0 PURPLE "assert [not] <function> <parameters>"
    return 0
  }

    if [ "$1" == "not" ]; then
        shift
        _assert_not "$*"
    else
        _assert "$*"
    fi
}

total_passed=0
total_failed=0

results() {
    is_true $TEST && {
        echo "" >> $OUTPUT
        echoc 1 YELLOW "-------------" >> $OUTPUT
        echoc 2 OK "Passed: $total_passed" >> $OUTPUT
        echoc 2 KO "Errors: $total_failed" >> $OUTPUT
        echoc 1 YELLOW "-------------" >> $OUTPUT
        echo "" >> $OUTPUT
    }

    [ -f $OUTPUT ] && cat $OUTPUT
} 

results_and_exit() {
    results

    is_true $TEST && {
        [ $total_failed -ne 0 ] && exit 1
        exit 0
    }

} 

help() {
    echoc 0 PURPLE "- i_menu : Interactive menu for setting options"
    echoc 0 PURPLE "- assert : The test function (see assert help for more)"
    echoc 0 PURPLE "- f_list : Print the functions list"
    echoc 0 PURPLE "- results : Print results"
    echoc 0 PURPLE "- results_and_exit : Print results and exit with code"
}

help

