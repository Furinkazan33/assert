#! /bin/bash

# TODO : Respond to : is it feasible in shell ?
# TODO : define grammar
# TODO : implement the parser

# Parsing function so that we can use a more readable syntax
# assert <object> <expression> 
#
# Examples :
#    assert my_variable is not numeric
#    assert my_function(a, b, c) returns 0
#    assert add(2, 4) echoed 6 and returns 0


LIB="./lib"
. assert.sh


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
echo "assert(p1,p2,p3,p4) gives :"
echo "function   : ${res[@]:0:1}"
echo "parameters : ${res[@]:1}"

