#! /bin/bash
. assert.sh


######################################
# Tests
######################################

# Optionnal, default value
TEST=0

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

assert positive 0 5 1845421 2 3 3
assert not positive 1 2 3 -1 4 5
assert negative -5 -1845421 -2 -3
assert not negative -1 -2 0 -1 -4

assert sorted_num_asc -4 0 2 5 7 9 13
assert not sorted_num_asc -4 0 2 8 7 9 13
assert sorted_num_desc 10 2 0 -5 -9

assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg
assert not sorted_asc zero bibi
assert not sorted_desc z y g a

######################################
# Assertions passed & failed
######################################
exit_with_totals

