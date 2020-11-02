#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# Functions to use with the assert function
#############################################################

# Only "0", "true" and "TRUE" are true
is_true()
{
  [ "$1" == "-u" ] && { echo "is_true <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Values are true iff true, TRUE or 0"; return 2; }

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
is_false()
{
  [ "$1" == "-u" ] && { echo "is_false <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Values are false iff not true"; return 2; }

 for value in $*; do

    if [[ $value =~ ^[0-9]+$ ]]; then
      [ $value -ne 1 ] && return 1
    else
      ([ ! "$value" == "false" ] && [ ! "$value" == "FALSE" ]) && return 1
    fi
  done

  return 0
}

alpha()
{
  [ "$1" == "-u" ] && { echo "alpha <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Values are alpha iff [[:alpha:]]"; return 2; }

 echo "$*" | grep -E "^([[:alpha:]]( )?){1,}$" &> /dev/null
}

alnum()
{
  [ "$1" == "-u" ] && { echo "alnum <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Values are alphanumeric iff [[:alnum:]]"; return 2; }

 echo "$*" | grep -E "^([[:alnum:]]( )?){1,}$" &> /dev/null
}

numeric()
{
  [ "$1" == "-u" ] && { echo "numeric <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Values are numeric iff positive or negative numbers"; return 2; }

 echo "$*" | grep -E "^((-)?[0-9]( )?){1,}$" &> /dev/null
}

empty()
{
  [ "$1" == "-u" ] && { echo "empty <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Values are empty iff length is 0"; return 2; }

 for value in $*; do
    [ ! -z "$value" ] && return 1
  done

  return 0
}

not_empty()
{
  [ "$1" == "-u" ] && { echo "not_empty <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Values are not empty iff length is not 0"; return 2; }

 for value in $*; do
    [ -z "$value" ] && return 1
  done

  return 0
}

eq()
{
  [ "$1" == "-u" ] && { echo "eq <value> <value>"; return 2; }
  [ "$1" == "-h" ] && { echo "Accepts string or numbers"; return 2; }

 numeric $1 && numeric $2 && [ $1 -eq $2 ] && return 0
  alnum "$1" && alnum "$2" && [ "$1" == "$2" ] && return 0
  return 1
}

gt()
{
  [ "$1" == "-u" ] && { echo "gt <value> <value>"; return 2; }
  [ "$1" == "-h" ] && { echo "Accepts string or numbers"; return 2; }

 numeric $1 && numeric $2 && [ $1 -gt $2 ] && return 0
  alnum "$1" && alnum "$2" && [[ "$1" > "$2" ]] && return 0
  return 1
}

ge()
{
  [ "$1" == "-u" ] && { echo "ge <value> <value>"; return 2; }
  [ "$1" == "-h" ] && { echo "Accepts string or numbers"; return 2; }

 numeric $1 && numeric $2 && [ $1 -ge $2 ] && return 0
  alnum "$1" && alnum "$2" && ([[ "$1" > "$2" ]] || [ "$1" == "$2" ]) && return 0
  return 1
}

lt()
{
  [ "$1" == "-u" ] && { echo "lt <value> <value>"; return 2; }
  [ "$1" == "-h" ] && { echo "Accepts string or numbers"; return 2; }

 numeric $1 && numeric $2 && [ $1 -lt $2 ] && return 0
  alnum "$1" && alnum "$2" && [[ "$1" < "$2" ]] && return 0
  return 1
}

le()
{
  [ "$1" == "-u" ] && { echo "le <value> <value>"; return 2; }
  [ "$1" == "-h" ] && { echo "Accepts string or numbers"; return 2; }

 numeric $1 && numeric $2 && [ $1 -le $2 ] && return 0
  alnum "$1" && alnum "$2" && ([[ "$1" < "$2" ]] || [ "$1" == "$2" ]) && return 0
  return 1
}

positive()
{
  [ "$1" == "-u" ] && { echo "positive <number list>"; return 2; }
  [ "$1" == "-h" ] && { echo "False if it contains a non numeric value"; return 2; }

 for n in $*; do
    ! numeric $n && return 1
    [ $n -lt 0 ] && return 1
  done

  return 0
}

negative()
{
  [ "$1" == "-u" ] && { echo "negative <number list>"; return 2; }
  [ "$1" == "-h" ] && { echo "False if it contains a non numeric value"; return 2; }

 for n in $*; do
    ! numeric $n && return 1
    [ $n -ge 0 ] && return 1
  done

  return 0
}

sorted_desc()
{
  [ "$1" == "-u" ] && { echo "sorted_desc <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Accept alphanumeric values"; return 2; }

 current=$1
  shift

  for next in $*; do
    [[ $next > $current ]] && return 1
    current=$next
  done

  return 0
}

sorted_asc()
{
  [ "$1" == "-u" ] && { echo "sorted_asc <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "Accept alphanumeric values"; return 2; }

 current=$1
  shift

  for next in $*; do
    [[ $next < $current ]] && return 1
    current=$next
  done

  return 0
}

sorted_num_desc()
{
  [ "$1" == "-u" ] && { echo "sorted_num_desc <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "False if it contains non numeric values"; return 2; }

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

sorted_num_asc()
{
  [ "$1" == "-u" ] && { echo "sorted_num_asc <values list>"; return 2; }
  [ "$1" == "-h" ] && { echo "False if it contains non numeric values"; return 2; }

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

_expression_usage() {
  echo 'expression "(expression)" [echoes <value>] [and] [returns <value>]'
}

expression()
{
  [ "$1" == "-u" ] && { _expression_usage; return 2; }
  [ "$1" == "-h" ] && { echo "The tested expression must be between double quotes and parentheses. It can be any shell expression (function call, script call, ..."; return 2; }

  regex="^\((.*)\)( echoes (.*) and returns (.*)| echoes (.*)| returns (.*))?$"

  if [[ "$*" =~ $regex ]]; then
    expression="${BASH_REMATCH[1]}"
    expecting="${BASH_REMATCH[2]}"
    #echo "1:${BASH_REMATCH[1]}"
    #echo "2:${BASH_REMATCH[2]}"
    #echo "3:${BASH_REMATCH[3]}"
    #echo "4:${BASH_REMATCH[4]}"
    #echo "5:${BASH_REMATCH[5]}"
      #echo "6:${BASH_REMATCH[6]}"
  else
    _expression_usage
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

