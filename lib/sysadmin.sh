#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# System administration functions
#############################################################

f_list() {
    echoc 3 DARK_BLUE 'is_admin [<usernames list>]'
    echoc 3 DARK_BLUE 'is_installed <packages list>'


    #echoc 3 DARK_BLUE 'expression "(<expression>)" [echoes <value>] [and] [returns <value>]'
    #echoc 3 DARK_BLUE 'expression "(<expression>)" is a shortcut for expression "(<expression>)" returns 0'
}


is_admin() {
    [ -z "$*" ] && (groups | grep -q sudo && return 0 || return 1)

    for user in $*; do
        groups $user | grep -q sudo || return 1
    done

    return 0
}

is_installed() {
    for p in $*; do
        command -v $p &> /dev/null || return 1
    done
    
    return 0
}


