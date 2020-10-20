# Assertion library to test shell scripts with colored report.

## Functions list (work in progress to add more) : 
```
is_true ("true", "TRUE" or "0")
is_false (not true)
alpha
numeric
alnum
positive
negative
all_positive (on a list)
all_negative (on a list)
sorted_desc (on a list)
sorted_asc (on a list)
sorted_num_desc (on a list)
sorted_num_asc (on a list)
expression (on any expression)
```

## In your tests scripts (test mode, ie TEST=true) :

### The following...

```
# Test mode (all outputs) - this is the default
TEST=true

# Continue on errors - this is the default
CONTINUE=true

assert alpha "sfhGJhgFJkHJK"
assert alnum "12h4gf3 GHFJk"
assert not all_positive 0 5 1845421 2 3 3
assert all_negative -5 -1845421 -2 -3
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
not all_positive 0 5 1845421 2 3 3 => failed
all_negative -5 -1845421 -2 -3 => passed
not sorted_num_asc -4 0 2 8 7 9 13 => passed
sorted_asc a f kgfhfgh pdfgdfg wdfgdfg => passed
expression (echo OK) echoes OK and returns 0 => passed
expression (func OK) echoes Working OK ! and returns 3 => passed
expression (func OK) echoes Working OK ! => passed
expression (func OK) returns 3 => passed

 ------------
  Passed: 8
  Errors: 2
 ------------
```

## Directly in your scripts (execution mode, ie TEST=false) :

### The following...

```
# Execution mode (no output)
TEST=false

# Stop on any error
CONTINUE=false

assert alpha "sfhGJhgFJkHJK"
assert alnum "12h4gf3 GHFJk"
assert not all_positive 0 5 1845421 2 3 3
assert all_negative -5 -1845421 -2 -3
assert not sorted_num_asc -4 0 2 8 7 9 13
assert sorted_asc a f kgfhfgh pdfgdfg wdfgdfg

exit_with_totals
```

### Will only produce 

```
assert alnum 12h4gf3 GHFJk => failed
```
