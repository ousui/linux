# use sh $0 /path/to/file password
#
#!/bin/sh
file=$1
passwd=$2
for host in `cat $file`; do
	expect -c "
	  spawn ssh-copy-id -f $host
	  expect \"*password:*\" { send \"$passwd\\r\"; }
	  expect \"kill\" { send \"ok\"; }
	"
done  

