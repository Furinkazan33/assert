# assert

Assertion library to test shell scripts.

-Example : 

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
assert sorted_desc z y g a

exit_with_totals


-Results : 

assert alpha sfhGJhgFJkHJK
  => passed

assert not alpha 123sf4hGJhgFJkHJK
  => passed

assert alnum 123sf4hGJhgFJkHJK
  => passed

assert not alnum 12h4gf3 GHFJk
  => passed

assert not alnum -_
  => passed

assert numeric 1247864315646874635413
  => passed

assert not numeric 123sf4hGJhgFJkHJK
  => passed

assert positive 0 5 1845421 2 3 3
  => passed

assert not positive 1 2 3 -1 4 5
  => passed

assert negative -5 -1845421 -2 -3
  => passed

assert not negative -1 -2 0 -1 -4
  => passed

assert sorted_num_asc -4 0 2 5 7 9 13
  => passed

assert not sorted_num_asc -4 0 2 8 7 9 13
  => passed

assert sorted_num_desc 10 2 0 -5 -9
  => passed

assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg
  => passed

assert not sorted_asc zero bibi
  => passed

assert sorted_desc z y g a
  => passed

 _

  Passed: 17
  Errors: 0
 _

