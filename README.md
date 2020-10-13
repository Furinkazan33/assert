# Assertion library to test shell scripts.

## Functions list (work in progress to add more) : 
```
alpha
alnum
numeric
positive
negative
sorted_desc
sorted_asc
sorted_num_desc
sorted_num_asc
```

## Example : 

```
assert alpha "sfhGJhgFJkHJK"
assert not alnum "12h4gf3 GHFJk"
assert positive 0 5 1845421 2 3 3
assert negative -5 -1845421 -2 -3
assert not negative -1 -2 0 -1 -4
assert not sorted_num_asc -4 0 2 8 7 9 13
assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg

exit_with_totals
```

## Results : 

```
assert alpha sfhGJhgFJkHJK
  => passed
assert not alnum 12h4gf3 GHFJk
  => passed
assert positive 0 5 1845421 2 3 3
  => passed
assert negative -5 -1845421 -2 -3
  => passed
assert not negative -1 -2 0 -1 -4
  => passed
assert not sorted_num_asc -4 0 2 8 7 9 13
  => passed
assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg
  => passed

 ------------
  Passed: 7
  Errors: 0
 ------------
```
