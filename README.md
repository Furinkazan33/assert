# Assertion library to test shell scripts with colored report.

## Functions list (work in progress to add more) : 
```
is_true ("true", "TRUE" or "0")
is_false (not true)
alpha <value>
numeric <value>
alnum <value>
positive <value>
negative <value>
all_positive <values list>
all_negative <values list>
sorted_desc <values list>
sorted_asc <values list>
sorted_num_desc <values list>
sorted_num_asc <values list>
expression (<expression>) [echoes <value>] [and] [returns <value>]
```

## Options

You can specify if you do not want a log file in your scripts by specifying the following : 

```
OUTPUT="/dev/stdout"
```

You can stop executing your scripts on any errors via the following :
```
CONTINUE=false or CONTINUE=1
```

You can prevent outputs of passing assertions via the following :
```
TEST=false or TEST=1
```

## Example, in your tests scripts (test mode, ie TEST=true)

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
assert expression "(./example.sh p1)" echoes "Usage: ./example.sh" and returns 1
assert expression "(invalid_command)"

exit_with_totals
```

### Will produce the following in a log file

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
expression (./example.sh p1) echoes Usage: ./example.sh and returns 1 => passed
expression (invalid_command) => failed

 ------------
  Passed: 9
  Errors: 3
 ------------
```

## Example, directly in your scripts (execution mode, ie TEST=false) :

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
An assertion failed during the execution of your script (alnum 12h4gf3 GHFJk)
```

# Feel free to contribute, or ask for improvements or help.
