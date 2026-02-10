--Case Statements

CASE "$VAR"
    pattern_1)
        # Commands go here
        ;;
    pattern_N)
        # commands go here
        ;;
esac

**Example
case "$1" in
    start)
        /usr/sbin/sshd
        ;;
    stop)
        kill $(cat /car/run/sshd.pid)
        ;;
esac

case "$1" in
    start)
        /usr/sbin/sshd
    stop)
        kill $(car /var/run/sshd.pid)
        ;;
    *)
        echo "Usage: $0 start|stop"; exit 1
        ;;
esac

read -p "Enter y or n: "ANSWER
case "$ANSWER" in
    [yY]|[yY][eE][sS])
        echo "You answered yes."
        ;;
    [nN|[nN][oO])]
        echo "You answered no."
        ;;
    *)
        echo "Invalid answer."
        ;;
esac

