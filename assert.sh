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
    color_echo 1 YELLOW "_"
    echo ""
    color_echo 2 ASSERTION_OK "Passed: $total_passed"
    color_echo 2 ASSERTION_KO "Errors: $total_failed"
    color_echo 1 YELLOW "_"
    echo ""
    [ $total_failed -ne 0 ] && exit 1
    exit 0
}


test() {
    local function=$1
    local params=${*:2}

    #echo "FUNC: $1 ($params)"
    res=$($function $params)
    RET_CODE=$?
    #[ ! -z "$res" ] && echo "ECHO: \"$res\""
    #echo "RETC: <$RET_CODE>"

    return $RET_CODE
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
    echo ""
    color_echo 0 DARK_BLUE "assert $*"

    if [ "$1" == "not" ]; then
        shift
        _assert_not $*
    else
        _assert $*
    fi
}





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


#res=($(extract_function "assert(p1,p2,p3,p4)"))
#echo "func ${res[@]:0:1}"
#echo "params ${res[@]:1}"

