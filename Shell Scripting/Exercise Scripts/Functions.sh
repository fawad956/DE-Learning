-- Functions

**Calling a Function
#! /bin/bash
function hello() {
    echo "Hello, World!"
}
hello

**Functions can call other functions
#! /bin/bash
function hello() {
    echo "Hello"
    now
}
function now() {
    echo "it's $(date +%r)"
}
hello

#! /bin/bash
my_function() {
    GLOBAL_VAR =1
}
#GLOBAL_VAR not available yet
echo $GLOBAL_VAR
my_function
#GLOBAL_VAR is now available
echo $GLOBAL_VAR
