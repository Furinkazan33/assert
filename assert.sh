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

LIB="./lib"

. $LIB/colors.sh
. $LIB/functions.sh

# By default, assert is for tests, so do not stop on errors
TEST=true
CONTINUE=true

_assertion_failed() {
    echoc 0 KO "$* => failed"
    total_failed=$(($total_failed + 1));
    is_false $CONTINUE && { echo "Stopping script (CONTINUE=$CONTINUE)"; exit 1; }
}

_assertion_passed() {
    is_true $TEST && echoc 0 OK "$* => passed"
    total_passed=$(($total_passed + 1))
}

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
    if [ "$1" == "not" ]; then
        shift
        _assert_not "$*"
    else
        _assert "$*"
    fi
}

total_passed=0
total_failed=0

exit_with_totals() {
    is_true $TEST && {
        echo ""
        echoc 1 YELLOW "-------------"
        echoc 2 OK "Passed: $total_passed"
        echoc 2 KO "Errors: $total_failed"
        echoc 1 YELLOW "-------------"
        echo ""
        [ $total_failed -ne 0 ] && exit 1
        exit 0
    }
}
