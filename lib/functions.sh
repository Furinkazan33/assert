#! /bin/bash

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
    for n in $*; do
        [ $n -lt 0 ] && return 1
    done

    return 0
}

negative() {
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
        echo "Usage: expression (expression) [echoes <value>] [and] [returns <value>]"
        echo "With expression is a function call, an echo, a subscript, ..."
    }

    regex="^\((.*)\)( echoes (.*) and returns (.*)| echoes (.*)| returns (.*))$"

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
        #echo "7:${BASH_REMATCH[7]}"
    else
        usage
        return 1
    fi

    expression_echo=$($expression)
    expression_return=$?

    local echoes returns

    if [ ! -z "${BASH_REMATCH[6]}" ]; then 
        [ $expression_return -ne ${BASH_REMATCH[6]} ] && return 1
        return 0

    elif [ ! -z "${BASH_REMATCH[5]}" ]; then
        [ "$expression_echo" != "${BASH_REMATCH[5]}" ] && return 1
        return 0
    else 
        [ "$expression_echo" != "${BASH_REMATCH[3]}" ] && return 1
        [ $expression_return -ne ${BASH_REMATCH[4]} ] && return 1
        return 0
    fi

    #echo "$expression $expression_echo $expression_return $echoes $returns"

    return 0
}