#! /bin/bash

######################################
# Colors
######################################
declare -A COLORS
COLORS[NO_COLOUR]="\033[0m"
COLORS[DARK_BLUE]="\033[1;34m"
COLORS[BLUE]="\033[36m"
COLORS[RED]="\033[91m"
COLORS[YELLOW]="\033[1;33m"
COLORS[GREEN]="\033[92m"
COLORS[LIGHTGREY]="\033[37m"
COLORS[ASSERTION_OK]=${COLORS[LIGHTGREY]}
COLORS[ASSERTION_KO]=${COLORS[RED]}


# echoc n_indent color string
echoc() {
    local indentation=$(head -c $1 < /dev/zero | tr '\0' '\40')
    local color=$2
    local mes=${*:3}

    echo -e "$indentation$color$mes${COLORS[NO_COLOUR]}"
}

assertion_failed() {
    echoc 2 ${COLORS[ASSERTION_KO]}"=> Assertion $* failed"
    total_failed=$(($total_failed + 1));
}

assertion_passed() {
    echoc 2 ${COLORS[ASSERTION_OK]}"=> Assertion $* passed"
    total_passed=$(($total_passed + 1))
}


total_passed=0
total_failed=0

exit_with_totals() {
    echo ""
    echoc 1 ${COLORS[YELLOW]}"_"
    echo ""
    echoc 2 ${COLORS[ASSERTION_OK]}"Passed: $total_passed"
    echoc 2 ${COLORS[ASSERTION_KO]}"Errors: $total_failed"
    echoc 1 ${COLORS[YELLOW]}"_"
    echo ""
    [ $total_failed -ne 0 ] && exit 1
    exit 0
}


test() {
    local function=$1
    local params=${*:2}

    echo "FUNC: $1 ($params)"
    res=$($function $params)
    RET_CODE=$?
    [ ! -z "$res" ] && echo "ECHO: \"$res\""
    echo "RETC: <$RET_CODE>"

    return $RET_CODE
}

_assert() {
    test $* || { assertion_failed $1; return 1; }

    assertion_passed $1

    return 0
}

_assert_not() {
    test $* && { assertion_failed not $1; return 1; }

    assertion_passed not $1

    return 0
}

assert() {
    echo ""
    echoc 0 ${COLORS[DARK_BLUE]}"assert $*"

    if [ "$1" == "not" ]; then
        shift
        _assert_not $*
    else
        _assert $*
    fi
}


######################################
# Functions to test
######################################
only_alnum(){
    echo "$*" | grep -E "^[[:alnum:]]{1,}$"
}


######################################
# Tests
######################################
string_alnum="123sf4hGJhgFJkHJK"
string_with_space="12h4gf3 GHFJk"
string_special="-_"

assert only_alnum $string_alnum
assert not only_alnum $string_with_space
assert not only_alnum $string_special


######################################
# Assertions passed & failed
######################################
#exit_with_totals



#assert [not] func_test([params]) [not] equal value


function extract_param() {
    local s_params="$*"

    #TODO: parse parameters P_PARAMS
    PARAM="[a-z]{1,}[a-zA-Z0-9]{1,}"
    pattern="((.{2,})(,)){0,}($PARAM){0,1}"

    #echo $s_params
    #echo $pattern

    if [[ $s_params =~ $pattern ]]; then
        #echo ${BASH_REMATCH[1]}
        echo ${BASH_REMATCH[2]}
        # reste
        #echo ${BASH_REMATCH[3]} # ,
        echo ${BASH_REMATCH[4]}
        # dernier param
        return 0
    fi
    
    echo "Error parse"

    exit 1
}

function extract_parameters() {
    local PARAMETERS=()
    local p_reste="$*"

    while true; do
        P=($(extract_param "$p_reste"))

        p_reste="${P[0]}"
        p_courant="${P[1]}"

        [ -z "$p_courant" ] && PARAMETERS+=($p_reste) && break

        PARAMETERS+=($p_courant)
    done

    echo ${PARAMETERS[@]}
}

function extract_function() {
    local s_function="$*"

    FUNCTION_NAME="([a-z]{1,}[a-zA-Z0-9_]{2,}){1}"
    FUNCTION="$FUNCTION_NAME(\()(.{0,})(\))"

    pattern=$FUNCTION
    #echo $s_function
    #echo $pattern

    if [[ $s_function =~ $pattern ]]; then
        P_FUNC=${BASH_REMATCH[1]}
        P_OP=${BASH_REMATCH[2]}
        P_PARAMS=${BASH_REMATCH[3]}
        P_CP=${BASH_REMATCH[4]}

        parameters=$(extract_parameters "$P_PARAMS")

        #echo "-------------"
        #echo "function name <$P_FUNC>, parameters <$parameters>"
        #echo "-------------"
        echo "$P_FUNC"
        echo "$parameters"
    else
        echo "Error parse"
        return 1
    fi
}


res=($(extract_function "assert(p1,p2,p3,p4)"))
echo "func ${res[@]:0:1}"
echo "params ${res[@]:1}"