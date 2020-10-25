#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# Functions to use with the assert function
#############################################################

f_list() {
    echoc 3 DARK_BLUE 'is_true <values list> (true, TRUE or 0)'
    echoc 3 DARK_BLUE 'is_false <values list> (not true)'
    echoc 3 DARK_BLUE 'alpha <values list>'
    echoc 3 DARK_BLUE 'numeric <numbers list>'
    echoc 3 DARK_BLUE 'alnum <values list>'
    echoc 3 DARK_BLUE 'empty <values list>'
    echoc 3 DARK_BLUE 'not_empty <values list>'
    echoc 3 DARK_BLUE 'eq <value> <value>'
    echoc 3 DARK_BLUE 'gt <value> <value>'
    echoc 3 DARK_BLUE 'ge <value> <value>'
    echoc 3 DARK_BLUE 'lt <value> <value>'
    echoc 3 DARK_BLUE 'le <value> <value>'
    echoc 3 DARK_BLUE 'positive <number list>'
    echoc 3 DARK_BLUE 'negative <number list>'
    echoc 3 DARK_BLUE 'sorted_desc <values list>'
    echoc 3 DARK_BLUE 'sorted_asc <values list>'
    echoc 3 DARK_BLUE 'sorted_num_desc <values list>'
    echoc 3 DARK_BLUE 'sorted_num_asc <values list>'
    echoc 3 DARK_BLUE 'expression "(<expression>)" [echoes <value>] [and] [returns <value>]'
    echoc 3 DARK_BLUE 'expression "(<expression>)" is a shortcut for expression "(<expression>)" returns 0'
}


# Only "0", "true" and "TRUE" are true
is_true() {
    for value in $*; do

        if [[ $value =~ ^[0-9]+$ ]]; then
            [ $value -ne 0 ] && return 1
        else
            ([ ! "$value" == "true" ] && [ ! "$value" == "TRUE" ]) && return 1
        fi
    done

    return 0
}

# Everything is false except when it's true
is_false() {
    for value in $*; do

        if [[ $value =~ ^[0-9]+$ ]]; then
            [ $value -ne 1 ] && return 1
        else
            ([ ! "$value" == "false" ] && [ ! "$value" == "FALSE" ]) && return 1
        fi
    done

    return 0
}

alpha(){
    echo "$*" | grep -E "^([[:alpha:]]( )?){1,}$" &> /dev/null
}

alnum(){
    echo "$*" | grep -E "^([[:alnum:]]( )?){1,}$" &> /dev/null
}

numeric(){
    echo "$*" | grep -E "^((-)?[0-9]( )?){1,}$" &> /dev/null
}

empty() {
    for value in $*; do
        [ ! -z "$value" ] && return 1
    done
    
    return 0
}

not_empty() {
    for value in $*; do
        [ -z "$value" ] && return 1
    done
    
    return 0
}

eq() {
    numeric $1 && numeric $2 && [ $1 -eq $2 ] && return 0
    alnum "$1" && alnum "$2" && [ "$1" == "$2" ] && return 0
    return 1
}

gt() {
    numeric $1 && numeric $2 && [ $1 -gt $2 ] && return 0
    alnum "$1" && alnum "$2" && [[ "$1" > "$2" ]] && return 0
    return 1
}

ge() {
    numeric $1 && numeric $2 && [ $1 -ge $2 ] && return 0
    alnum "$1" && alnum "$2" && ([[ "$1" > "$2" ]] || [ "$1" == "$2" ]) && return 0
    return 1
}

lt() {
    numeric $1 && numeric $2 && [ $1 -lt $2 ] && return 0
    alnum "$1" && alnum "$2" && [[ "$1" < "$2" ]] && return 0
    return 1
}

le() {
    numeric $1 && numeric $2 && [ $1 -le $2 ] && return 0
    alnum "$1" && alnum "$2" && ([[ "$1" < "$2" ]] || [ "$1" == "$2" ]) && return 0
    return 1
}

positive() {
    for n in $*; do
        ! numeric $n && return 1
        [ $n -lt 0 ] && return 1
    done

    return 0
}

negative() {
    for n in $*; do
        ! numeric $n && return 1
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

    ! numeric $current && return 1

    for next in $*; do
        ! numeric $next && return 1
        [ $next -gt $current ] && return 1
        current=$next
    done

    return 0
}

sorted_num_asc() {
    current=$1
    shift

    ! numeric $current && return 1

    for next in $*; do
        ! numeric $next && return 1
        [ $next -lt $current ] && return 1
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

