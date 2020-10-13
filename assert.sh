#! /bin/bash
LIB="./lib"

. $LIB/colors.sh
. $LIB/functions.sh


assertion_failed() {
    color_echo 2 ASSERTION_KO "=> failed"
    total_failed=$(($total_failed + 1));
}

assertion_passed() {
    color_echo 2 ASSERTION_OK "=> passed"
    total_passed=$(($total_passed + 1))
}


total_passed=0
total_failed=0

exit_with_totals() {
    echo ""
    color_echo 1 YELLOW "-------------"
    color_echo 2 ASSERTION_OK "Passed: $total_passed"
    color_echo 2 ASSERTION_KO "Errors: $total_failed"
    color_echo 1 YELLOW "-------------"
    echo ""
    [ $total_failed -ne 0 ] && exit 1
    exit 0
}


test() {
    local function=$1
    local params=${*:2}

    $function $params
    
    return $?
}

_assert() {
    test $* || { assertion_failed $1; return 1; }

    assertion_passed

    return 0
}

_assert_not() {
    test $* && { assertion_failed not $1; return 1; }

    assertion_passed

    return 0
}

assert() {
    color_echo 0 DARK_BLUE "assert $*"

    if [ "$1" == "not" ]; then
        shift
        _assert_not $*
    else
        _assert $*
    fi
}

