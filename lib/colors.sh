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
COLORS[ASSERTION_OK]=${COLORS[GREEN]}
COLORS[ASSERTION_KO]=${COLORS[RED]}


# echoc n_indent color string
color_echo() {
    local indentation=$(head -c $1 < /dev/zero | tr '\0' '\40')
    local color=$2
    local mes=${*:3}

    echo -e "$indentation${COLORS[$color]}$mes${COLORS[NO_COLOUR]}"
}

color_list() {
    for color in ${!COLORS[@]}; do
        echo $color
    done | sort
}

