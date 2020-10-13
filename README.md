# Assertion library to test shell scripts with colored report.

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

## In your tests scripts (test mode) :

### The following...

```
assert alpha "sfhGJhgFJkHJK"
assert alnum "12h4gf3 GHFJk"
assert not positive 0 5 1845421 2 3 3
assert negative -5 -1845421 -2 -3
assert not sorted_num_asc -4 0 2 8 7 9 13
assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg

exit_with_totals
```

### Will produce 

```
assert alpha sfhGJhgFJkHJK => passed
assert alnum "12h4gf3 GHFJk" => failed
assert not positive 0 5 1845421 2 3 3 => failed
assert negative -5 -1845421 -2 -3 => passed
assert not sorted_num_asc -4 0 2 8 7 9 13 => passed
assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg => passed

 ------------
  Passed: 4
  Errors: 2
 ------------
```

## Directly in your scripts (execution mode) :

### The following...

```
TEST=1
CONTINUE=1
assert alpha "sfhGJhgFJkHJK"
assert alnum "12h4gf3 GHFJk"
assert not positive 0 5 1845421 2 3 3
assert negative -5 -1845421 -2 -3
assert not sorted_num_asc -4 0 2 8 7 9 13
assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg

exit_with_totals
```

### Will produce 

```
assert alnum 12h4gf3 GHFJk => failed
```
