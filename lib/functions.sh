#! /bin/bash

# Only "0", "true" and "TRUE" are true
is_true() {
    local value="$*"

    if [[ $value =~ ^[0-9]+$ ]]; then
        [ $value -eq 0 ] && return 0
    else
        ([ "$value" == "true" ] || [ "$value" == "TRUE" ]) && return 0
    fi

    return 1
}

# Everything is false except when it's true
is_false() {
    is_true "$*" || return 0
    return 1
}

alpha(){
    echo "$*" | grep -E "^[[:alpha:]]{1,}$" &> /dev/null
}

alnum(){
    echo "$*" | grep -E "^[[:alnum:]]{1,}$" &> /dev/null
}

numeric(){
    echo "$*" | grep -E "^[0-9]{1,}$" &> /dev/null
}

positive() {
    [ $1 -ge 0 ] && return 0

    return 1
}

negative() {
    [ $1 -lt 0 ] && return 0

    return 1
}

# All >=0
all_positive() {
    for n in $*; do
        [ $n -lt 0 ] && return 1
    done

    return 0
}

# All <0
all_negative() {
    for n in $*; do
        [ $n -ge 0 ] && return 1
    done

    return 0
}

sorted_desc() {
    current=$1
    shift

    for next in $*; do
        [[ $next > $current ]] && return 1
        current=$next
    done

    return 0
}

sorted_asc() {
    current=$1
    shift

    for next in $*; do
        [[ $next < $current ]] && return 1
        current=$next
    done

    return 0
}

sorted_num_desc() {
    current=$1
    shift

    for next in $*; do
        [[ $next -gt $current ]] && return 1
        current=$next
    done

    return 0
}

sorted_num_asc() {
    current=$1
    shift

    for next in $*; do
        [[ $next -lt $current ]] && return 1
        current=$next
    done

    return 0
}

expression() {
    usage() {
        echo 'Usage: expression "(expression)" [echoes <value>] [and] [returns <value>]'
        echo "With expression is a function call, an echo, a subscript, ..."
    }

    regex="^\((.*)\)( echoes (.*) and returns (.*)| echoes (.*)| returns (.*))?$"

    if [[ "$*" =~ $regex ]]
    then
        expression="${BASH_REMATCH[1]}"
        expecting="${BASH_REMATCH[2]}"
        #echo "1:${BASH_REMATCH[1]}"
        #echo "2:${BASH_REMATCH[2]}"
        #echo "3:${BASH_REMATCH[3]}"
        #echo "4:${BASH_REMATCH[4]}"
        #echo "5:${BASH_REMATCH[5]}"
        #echo "6:${BASH_REMATCH[6]}"
    else
        usage
        return 1
    fi

    expression_echo=$(eval $expression 2> /dev/null)
    expression_return=$?

    local echoes returns

    # Only returns
    if [ ! -z "${BASH_REMATCH[6]}" ]; then 
        [ $expression_return -ne ${BASH_REMATCH[6]} ] && return 1
        return 0

    # Only echoes
    elif [ ! -z "${BASH_REMATCH[5]}" ]; then
        [ "$expression_echo" != "${BASH_REMATCH[5]}" ] && return 1
        return 0

    # Only expression
    elif [ -z "${BASH_REMATCH[4]}" ] && [ -z "${BASH_REMATCH[3]}" ] && [ -z "${BASH_REMATCH[2]}" ]; then
        [ $expression_return -ne 0 ] && return 1
        return 0

    # returns and echoes
    else
        [ "$expression_echo" != "${BASH_REMATCH[3]}" ] && return 1
        [ $expression_return -ne ${BASH_REMATCH[4]} ] && return 1
        return 0
    fi

    #echo "$expression $expression_echo $expression_return $echoes $returns"

    return 0
}


functions_list() {
    echoc 3 DARK_BLUE 'is_true (true, TRUE or 0)'
    echoc 3 DARK_BLUE 'is_false (not true)'
    echoc 3 DARK_BLUE 'alpha <value>'
    echoc 3 DARK_BLUE 'numeric <value>'
    echoc 3 DARK_BLUE 'alnum <value>'
    echoc 3 DARK_BLUE 'positive <value>'
    echoc 3 DARK_BLUE 'negative <value>'
    echoc 3 DARK_BLUE 'all_positive <values list>'
    echoc 3 DARK_BLUE 'all_negative <values list>'
    echoc 3 DARK_BLUE 'sorted_desc <values list>'
    echoc 3 DARK_BLUE 'sorted_asc <values list>'
    echoc 3 DARK_BLUE 'sorted_num_desc <values list>'
    echoc 3 DARK_BLUE 'sorted_num_asc <values list>'
    echoc 3 DARK_BLUE 'expression "(<expression>)" [echoes <value>] [and] [returns <value>]'
}