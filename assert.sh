#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# assert function to test scripts
# Do the following to use directly in your scripts :
# TEST=1 will disable echoes of passed tests
# (optionnal) CONTINUE=1 will stop execution on error
#############################################################

LIB="./lib"

. $LIB/colors.sh
. $LIB/functions.sh

# By default, assert is for tests, so do not stop on errors
TEST=0
CONTINUE=0

_assertion_failed() {
    color_echo 0 ASSERTION_KO "$* => failed"
    total_failed=$(($total_failed + 1));
    [ $CONTINUE -eq 1 ] && { echo "Stopping script (CONTINUE=$CONTINUE)"; exit 1; }
}

_assertion_passed() {
    [ $TEST -eq 0 ] && color_echo 0 ASSERTION_OK "$* => passed"
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
    [ $TEST -eq 0 ] && {
        echo ""
        color_echo 1 YELLOW "-------------"
        color_echo 2 ASSERTION_OK "Passed: $total_passed"
        color_echo 2 ASSERTION_KO "Errors: $total_failed"
        color_echo 1 YELLOW "-------------"
        echo ""
        [ $total_failed -ne 0 ] && exit 1
        exit 0
    }
}
