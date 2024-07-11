#This Script will prompt for T or F, for DeepFreeze command to Freeze or Thaw

#!/usr/bin/expect -f

set timeout 10

proc color_puts {color text} {
    puts -nonewline "\033\[0;${color}m$text\033\[0m"
}

set user_admin "Administrator"
set pass "Admin_pass"
set dfpass "Deep_Pass"
set tcommand "export DFXPSWD=${dfpass} && /usr/local/bin/deepfreeze thaw --computer --env"
set fcommand "export DFXPSWD=${dfpass} && /usr/local/bin/deepfreeze freeze --computer --env"
set restartcmd "echo '$pass' | sudo -S shutdown -r now"
set IFS "\t"

# Set Host File with Hostname and IP Tab seperated

set file [open "2054" r]

puts "Do you want to Thaw or Freeze? (T / F)"

expect_user -re "(F|T)" {
    set input $expect_out(1,string)
}

if { $input == "T" } {
    while { [gets $file line] != -1 } {
        set fields [split $line $IFS]
        set host [lindex $fields 0]
        set ip [lindex $fields 1]
        puts "\n"
        puts -nonewline [color_puts "33" "$host "]
        puts [color_puts "32" "$ip"]
        puts "------------------------------------"
        puts "\n"
        spawn ssh $user_admin@$ip $tcommand
        expect {
            "Are you sure you want to continue connecting*" {
                send "yes\r"
                exp_continue
            }
            "assword:" {
                send "$pass\r"
                exp_continue
            }
            "assword:" {
                send "$dfpass\r"
                exp_continue
            }
        }
        spawn ssh $user_admin@$ip sleep 3
        spawn ssh $user_admin@$ip $restartcmd
    }
} elseif { $input == "F" } {
    while { [gets $file line] != -1 } {
        set fields [split $line $IFS]
        set host [lindex $fields 0]
        set ip [lindex $fields 1]
        puts "\n"
        puts -nonewline [color_puts "33" "$host "]
        puts [color_puts "32" "$ip"]
        puts "------------------------------------"
        puts "\n"
        spawn ssh $user_admin@$host.local $fcommand
        expect {
            "Are you sure you want to continue connecting*" {
                send "yes\r"
                exp_continue
            }
            "assword:" {
                send "$dfpass\r"
                exp_continue
            }
        }
        spawn ssh $user_admin@$ip $fcommand
    }
} else {
   puts "Invalid input"
}

close $file
