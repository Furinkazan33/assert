
# Assertion library to test shell scripts

**Features**
- usable in command line, in your scripts (execution mode) or in your tests scripts (test mode)
- colored report
- enable/disable outputs to stdout or log file
- enable/disable stopping on errors
- common tests functions : ```assert [not] <function> <parameters>```
- complex expressions grammar : ```assert [not] expression "(any code here)" [echoes <something>] [and] [returns <value>]```
- interactive menu for setting options
- work in progress : adding more keywords to the expression grammar (stdout, stderr, empty, contains, is, not-contains, etc ...)

**Options**
- You can specify if you do not want a log file by specifying the following : ```OUTPUT="/dev/stdout"```
- You can stop executing your scripts on any errors via the following : ```CONTINUE=false or CONTINUE=1```
- You can prevent outputs of passing assertions via the following : ```TEST=false or TEST=1```

**User commands**
```
assert_menu           : Interactive menu for setting options
assert_functions [-h] : Display functions list (-h for help)
assert [-h]           : The test function (-h for help)
assert_results        : Display a brief summary
assert_exit_code      : Exit with code
```

**Functions**
```
is_true <values list>
is_false <values list>
alpha <values list>
numeric <values list>
alnum <values list>
empty <values list>
not_empty <values list>
eq <value> <value>
gt <value> <value>
ge <value> <value>
lt <value> <value>
le <value> <value>
positive <numbers list>
negative <numbers list>
sorted_desc <values list>
sorted_asc <values list>
sorted_num_desc <numbers list>
sorted_num_asc <numbers list>
expression "(<expression>)" [echoes <value>] [and] [returns <value>]
```

## Examples

**For complete examples, see the examples folder**
```
cd examples
chmod u+x example*
./example1.sh
./example2.sh
```

### Command line
```
$ . assert.sh
$ OUTPUT="/dev/stdout"

$ assert is_true 0 true   0   TRUE
is_true 0 true 0 TRUE => passed

$ assert expression "(echo "OK"; exit 2)" echoes "OK" and returns 2
expression (echo OK; exit 2) echoes OK and returns 2 => passed

$ assert positive 0 1 3 -4
positive 0 1 3 -4 => failed

$ results

 -------------
  Passed: 2
  Errors: 1
 -------------

```

### Tests scripts (TEST=true)

The following...
```
# Test mode (all outputs) - this is the default
TEST=true

# Continue on errors - this is the default
CONTINUE=true

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
assert expression "(./example.sh p1)" echoes "Usage: ./example.sh" and returns 1
assert not expression "(invalid_command)"

results
exit_with_code
```

...will produce the following in a log file
```
alpha sfhGJhgFJkHJK => passed
alnum "12h4gf3 GHFJk" => failed
not positive 0 5 1845421 2 3 3 => failed
negative -5 -1845421 -2 -3 => passed
not sorted_num_asc -4 0 2 8 7 9 13 => passed
sorted_asc a f kgfhfgh pdfgdfg wdfgdfg => passed
expression (echo OK) echoes OK and returns 0 => passed
expression (func OK) echoes Working OK ! and returns 3 => passed
expression (func OK) echoes Working OK ! => passed
expression (func OK) returns 3 => passed
expression (./example.sh p1) echoes Usage: ./example.sh and returns 1 => passed
not expression (invalid_command) => passed

 ------------
  Passed: 10
  Errors: 2
 ------------
```

### Execution scripts (TEST=false)

The following...
```
# Execution mode (no output)
TEST=false

# Stop on any error
CONTINUE=false

assert alpha "sfhGJhgFJkHJK"
assert alnum "12h4gf3 GHFJk"

echo "This doesn't occur"
```

...will only produce 
```
An assertion failed during the execution of your script (alnum 12h4gf3 GHFJk)
```


# Feel free to contribute, or ask for improvements or help.

