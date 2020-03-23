#!/bin/bash

ip=127.0.0.1
user=ubuntu
passwd=ubuntu
file=hello.txt
packages_pool=v3r2
dir=hello

/usr/bin/expect << EOF
set ip $ip
set file $file
set dir $dir
set user $user
set passwd $passwd
set timeout 120
spawn ftp $ip

expect { 
  "Name*" { send "$user\r" } 
}
expect { 
  "Password*" { send "$passwd\r" } 
}
expect { 
  "ftp>" { send "mkdir $packages_pool\r" } 
}
expect { 
  "ftp>" { send "cd $packages_pool\r" } 
}
expect { 
  "ftp>" { send "mkdir $dir\r" } 
}
expect { 
  "ftp>" { send "cd $dir\r" } 
}
expect { 
  "ftp>" { send "put $file\r" } 
}
expect { 
  "ftp>" { send "quit\r" } 
}

EOF