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

