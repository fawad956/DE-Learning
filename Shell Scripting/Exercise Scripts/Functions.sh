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

function backup_file() {
    if [ -f $1]
    then
       BACK="/tmp/$$(basename ${1}).$(date +&F).$$"
       echo "Backing up $1 tp ${BACK}"
       cp $1 $BACK
    fi
}
backup_file /etc/hosts
if [ $? -eq 0]
then
    echo "Backup successful"
fi

**With elif
function backup_file() {
    if [ -f $1]
    then
        local BACK="/tmp/$(basename ${1}).$(date +&F).SS"
        echo "Backing up $1 to ${BACK}"
        #The exit status of the function will be the exit status of the cp command
        cp $1 $BACK
    else
        #The does not exist
        return 1
    
}


