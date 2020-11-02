#! /bin/bash
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# assert function to test scripts
# Do the following to use directly in your scripts :
# TEST=false will disable echoes of passed tests
# (optionnal) CONTINUE=false will stop execution on error
#############################################################

LIB=$(dirname "${BASH_SOURCE[0]}")/lib

. $LIB/colors.sh
. $LIB/functions.sh
. $LIB/utils.sh

# By default, assert is for tests, so do not stop on errors
TEST=true
CONTINUE=true

# Creating logs folder
LOGS="logs"
mkdir $LOGS 2> /dev/null

# Output file, set as "/dev/stdout" to output to stdout
#OUTPUT="/dev/stdout"
OUTPUT="$LOGS/execution_$(date +%Y_%m_%d_%s).log"

_assertion_failed()
{
  is_true $TEST && echoc 0 KO "$* => failed" || echoc 0 KO "An assertion failed during the execution of your script ($*)"
  total_failed=$(($total_failed + 1));
  is_false $CONTINUE && { echo "Stopping script (CONTINUE=$CONTINUE)"; exit 1; }
} >> $OUTPUT

_assertion_passed()
{
  is_true $TEST && echoc 0 OK "$* => passed"
  total_passed=$(($total_passed + 1))
} >> $OUTPUT

_test()
{
  [ "$1" == "not" ] && { not=0; shift; } || { not=1; }

  local function=$1
  local params=${*:2}

  $function $params

  local ret_code=$?

  [ $not -eq 1 ] && { return $ret_code; }

  [ $ret_code -eq 0 ] && { return 1; } || { return 0; }
}

assert()
{
  [ "$1" == "-h" ] && { echoc 0 PURPLE "assert [not] <function> <parameters>"; return 0; }

  _test $* && { _assertion_passed "$*"; return 0; } || { _assertion_failed "$*"; return 1; }
}

total_passed=0
total_failed=0

assert_results()
{
  is_true $TEST && 
    {
      redirect_start $OUTPUT
      echo ""
      echoc 1 YELLOW "-------------"
      echoc 2 OK "Passed: $total_passed"
      echoc 2 KO "Errors: $total_failed"
      echoc 1 YELLOW "-------------"
      echo ""
      redirect_stop
    }

  [ -f $OUTPUT ] && cat $OUTPUT
}

assert_exit_code()
{
  [ $total_failed -ne 0 ] && exit 1 || exit 0
}

assert_menu()
{
  accept "Stop on error"  && CONTINUE=false
  accept "Output only errors" && TEST=false
  accept "Output to stdout" && OUTPUT="/dev/stdout"
}

assert_functions()
{
  [ "$1" == "-h" ] && echo "Here is the result of the $(echoc 0 DARK_BLUE \"-u\") and $(echoc 0 BLUE \"-h\") options on these functions :"

  functions=$(grep "()" $LIB/functions.sh | grep -v usage | cut -d"(" -f1)

  for f in $functions; do
    echoc 0 DARK_BLUE $($f -u)
    [ "$1" == "-h" ] && echoc 1 BLUE $($f -h)
  done
}

assert_help()
{
  echoc 0 PURPLE "- assert_menu           : Interactive menu for setting options"
  echoc 0 PURPLE "- assert_functions [-h] : Print the functions list (see -h for help)"
  echoc 0 PURPLE "- assert [-h]           : The test function (see -h for help)"
  echoc 0 PURPLE "- assert_results        : Print results"
  echoc 0 PURPLE "- assert_exit_code      : Exit with code"
}


