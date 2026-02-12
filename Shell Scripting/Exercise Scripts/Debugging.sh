--Debugging

#! /bin/bash
TEST_VAR="test"
set -x
echo $TEST_VAR
set +x
hostname
+echo test
test
+set +x
linuxsvr


#! /bin/bash -v
TEST_VAR ="test"
echo "$TEST_VAR"

