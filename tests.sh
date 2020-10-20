#! /bin/bash
. assert.sh


######################################
# Tests
######################################

# Optionnal, default value
TEST=true

string_alpha="sfhGJhgFJkHJK"
string_alnum="123sf4hGJhgFJkHJK"
string_with_space="12h4gf3 GHFJk"
string_special="-_"
string_numeric="1247864315646874635413"

assert alpha $string_alpha
assert not alpha $string_alnum

assert alnum $string_alnum
assert not alnum $string_with_space
assert not alnum $string_special

assert numeric $string_numeric
assert not numeric $string_alnum

assert all_positive 0 5 1845421 2 3 3
assert not all_positive 1 2 3 -1 4 5
assert all_negative -5 -1845421 -2 -3
assert not all_negative -1 -2 0 -1 -4

assert sorted_num_asc -4 0 2 5 7 9 13
assert not sorted_num_asc -4 0 2 8 7 9 13
assert sorted_num_desc 10 2 0 -5 -9

assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg
assert not sorted_asc zero bibi
assert not sorted_desc z y g a

assert expression "(echo ok)" echoes ok and returns 0
func() { echo "Working $1 !"; return 3; }
assert expression "(func OK)" echoes "Working OK !" and returns 3
assert expression "(func OK)" echoes "Working OK !"
assert expression "(func OK)" returns 3


######################################
# Assertions passed & failed
######################################
exit_with_totals

