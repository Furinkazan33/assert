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
expression
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
assert expression "(echo ok)" echoes ok and returns 0
func() { echo "Working $1 !"; return 3; }
assert expression "(func OK)" echoes "Working OK !" and returns 3
assert expression "(func OK)" echoes "Working OK !"
assert expression "(func OK)" returns 3

exit_with_totals
```

### Will produce 

```
alpha sfhGJhgFJkHJK => passed
alnum "12h4gf3 GHFJk" => failed
not positive 0 5 1845421 2 3 3 => failed
negative -5 -1845421 -2 -3 => passed
not sorted_num_asc -4 0 2 8 7 9 13 => passed
sorted_asc a f kgfhfgh pdfgdfg wdfgdfg => passed
expression (echo ok) echoes ok and returns 0 => passed
expression (func OK) echoes Working OK ! and returns 3 => passed
expression (func OK) echoes Working OK ! => passed
expression (func OK) returns 3 => passed

 ------------
  Passed: 8
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

### Will only produce 

```
assert alnum 12h4gf3 GHFJk => failed
```
