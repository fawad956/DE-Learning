--Exit Statuses & Return Codes


**Checking the Exit Status
ls /not/here
echo "$?"

**Testing the network connectivity to google.com
HOST = "google.com"
ping -c 1 $HOST
if [ "$?" -eq "0"]
then
    echo "$HOST reachable"
else
    echo "$HOST not reachable"
fi

** && ad=nd || operators
&& = AND
mkdir /mtmp/bak && cp test.txt /tmp/bak/
&& = OR
cp test. txt /tmp/bak/ || cp test.txt /tmp
