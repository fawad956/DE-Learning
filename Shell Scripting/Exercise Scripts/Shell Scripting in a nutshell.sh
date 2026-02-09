#!/ bin bash
sleep 90


**Variable usage
#! /bin/bash
MY_SHELL ="bash
echo "I like $MY_SHELL shell"

#! /bin/bash
MY_SHELL ="bash
echo "I like ${MY_SHELL}ing on my keyboard."

**Assign command output to a variable
#! bin/bash
SERVER_NAME=$(hostname)
echo "you are running this script on $ {SERVER_NAME}"

**Varable Names
**Valid
FIRST3LETTERS="ABC"
FIRST_THREE_LATTERS="ABC"
firstThreeLetters="ABC"

**File Operators (tests)
-d FILE **True if file is a directory
-e FILE **True if file exists
-f FILE **True if file exists and is a regular file
-r FILE **True if file is readable by you
-s FILE **True if file exists and is not empty
-w FILE **True if file is writable by you
-x FILE **True if file is executable by you

**String Operators (tests)
-z STRING **True if string is empty
-n STRING ** True if string is not empty
STRING1 = STRING2
    True if the strings are equal
STRING1 != STRING2
    True if the strings are not equal

**Arithmetic Operators (tests)
arg1 -eq arg2 **True if arg1 is equal to arg2
arg1 -ne arg2 **True if arg1 is not equal to arg2

arg1 -lt arg2 **True if arg1 is less than arg2
arg1 -le arg2 **True if arg1 is less than or equal to arg2

arg1 -gt arg2 **True if arg1 is greater than arg2
arg1 -ge arg2 **True if arg1 is greater than or equal to arg2

**Making Decisions - The if statement
if [condition-is-true]
then 
    command 1
    command 2
    command n
fi

**Example of if statement
#! /bin/bash
MY_SHELL="bash"
if ["$MY_SHELL" = "BASH"]
then
    echo "You seem to like the bash shell"
fi

** if/else
if [condition-is-true]
then 
    command N
else 
    command N
fi

**Example of if/else
#! /bin/bash
MY_SHELL="csh"
if ["$MY_SHELL" = "BASH"]
then
    echo "You seem to like the bash shell"
else
    echo "You don't seem to like the bash shell"
fi

** if/elif/else
if [condition-is-true]
then 
    command N
elif [condition-is-true]
then
    command N
else 
    command N
fi

**Example of if/elif/else
#! /bin/bash
MY_SHELL="csh"
if ["$MY_SHELL" = "BASH"]
then
    echo "You seem to like the bash shell"
elif["$MY_SHELL" = "CSH"]
then
    echo "You seem to like the csh shell"
else
    echo "You don't seem to like the bash shell or csh shells"
fi

** ForLoop
for VARIABLE_NAME in ITEM_1 ITEM_N 
do 
    command 1
    command 2
    command N
done

**Example of for loop
#! /bin/bash
for COLOR in red green blue
do
    echo "COLOR: $COLOR"
done

#! bin/bash
COLORS ="red green blue"
for COLOR in $COLORS
do
    echo "COLOR: $COLOR"
done

#! /bin/bash
PICTURES =$(ls *jpg)
DATE =$(date +%F)

for PICTURE in $PICTURES
do
    echi "Renaming ${PICTURE} to ${DATE} - ${PICTURE}"
    mv $PICTURE ${DATE} - ${PICTURE}
done

**Postional Parameters
$script.sh parameter1 parameter2 parameter3

$0:"script.sh"
$1:"parameter1"
$2:"parameter2"
$3:"parameter3"

**Example of postional parameters
#! /bin/bash
echo "Executing script: $0"
echo "Archiving user: $1"

#Lock the account
passwd -1 $1

#Create an arhive of the home directory
tar cf /archives/${1}.tar.gz /home/${1}

#! /bin/bash
echo "Executing script: $0"
for USER in $@
do
    echo "Archiving user: $USER"
    #Lock the account
    passwd -1 $USER

    #Create an arhive of the home directory
    tar cf /archives/${USER}.tar.gz /home/${USER}
done

**Accepting User Input(STDIN)
the real command accept STDIN

read -p "PROMPT" VARIABLE

#! /bin/bash
read -p "Enter a user name:" USER
echo "Archiving user: $USER"

#lock the account
passwd -1 $USER

#Create an archive of the home directory
tar cf /archives/${USER}.tar.gz /home/${USER}
