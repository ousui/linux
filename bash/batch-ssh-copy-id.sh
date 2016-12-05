# use sh $0 /path/to/file password
#
#!/bin/sh
file=$0
passwd=$1
for host in `cat $file`; do
	expect -c "
	spawn ssh-copy-id $host
	  expect {
		\"*password*\"{send \"$passwd\r\";exp_continue}
		\"*Password*\"{send \"$passwd\r\";}
	  }
	"
done  

