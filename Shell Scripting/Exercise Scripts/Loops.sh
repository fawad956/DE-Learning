--Loops

**While Loop Format
while [CONDITION_IS_TRUE]
do
    command 1
    command 2
    command N
done

**Infinite Loop
while [CONSITION_IS_TRUE]
do
    #Commands do NOT change
    #the condition
    command N
done

**Example - Loop 5 times
INDEX=1
while [ $INDEX -lt 6]
do
    echo "Creating project -${INDEX}"
    mkdir /usr/local/project-${INDEX}
    ((INDEX++))
    done

**Example - Checking User Input
while [ "$CORRECT" != "y"]
do
    read -p "Enter your name: " NAME
    read -p "IS ${NAME} correct? " CORRECT
done

**Example - Return Code of Command
while ping -c 1 app1 >/dev/null
do
    echo "app1 still up..."
    sleep 5
done
echo "app1 is down"

**Reading a file, line by line
LINE_NUM = 1
while read LINE
do
    echi "${LINE_NUM}: ${LINE}"
    ((LINE_NUM++))
done < /etc/fstab

FS_NUM=1
grep xfs /etc/fstab | while read FS MP REST
do
    echo "${FS_NUM}: file system: ${FS}"
    echo "${FS_NUM}: mount point: ${MP}"
    ((FS_NUM++))
done