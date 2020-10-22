#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# Colors
#############################################################

declare -A COLORS
COLORS[NO_COLOUR]="\033[0m"
COLORS[GREY]="\033[1;30m"
COLORS[RED]="\033[1;31m"
COLORS[GREEN]="\033[1;32m"
COLORS[YELLOW]="\033[1;33m"
COLORS[DARK_BLUE]="\033[1;34m"
COLORS[PURPLE]="\033[1;35m"
COLORS[BLUE]="\033[1;36m"
COLORS[LIGHTGREY]="\033[1;37m"
COLORS[BLACK]="\033[1;38m"
COLORS[OK]=${COLORS[GREEN]}
COLORS[KO]=${COLORS[RED]}

_color_list() {
    for color in ${!COLORS[@]}; do
        echo $color
    done | sort
}

_color() {
    echo "${COLORS[$1]}" 2> /dev/null
}

# echoc n_indent string
echoi() {
    usage() { 
        echo "Usage: echoi <number of indent> <message>" 
    }

    [ $# -lt 2 ] && { usage; return 1; }
    [[ ! $1 =~ ^[0-9]+$ ]] && { usage; return 1; }

    local indentation=$(head -c $1 < /dev/zero | tr '\0' '\40')
    local mes=${*:2}

    echo "$indentation$mes"
}

# echoc n_indent color string
echoc() {
    usage() {
        echo "Usage: echoc <number of indent> <color> <message>"
        echo "Colors list :"
        _color_list
    }

    color=$(_color $2)

    ([ $# -lt 3 ] || [[ ! $1 =~ ^[0-9]+$ ]] || [ -z $color ]) && { usage; return 1; }

    local message=$(echoi $1 ${*:3})
    local end_color=$(_color NO_COLOUR)

    echo -e "$color$message$end_color"
}



