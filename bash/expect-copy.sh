#!/usr/bin/expect
echo $1
spawn ssh-copy-id chanjet-ali-b-36.31
expect "*password:*"
send "chanjet0-=\r"
expect "*#"
