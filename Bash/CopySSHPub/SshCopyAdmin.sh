#!/usr/bin/expect -f

set timeout 10

proc color_puts {color text} {
    puts -nonewline "\033\[0;${color}m$text\033\[0m"
}

set user_admin "Administrator"

# Define the password variable
set pass "YourPass"

# Set the Internal Field Separator to tab
set IFS "\t"

# Open the file for reading
set file [open "2054" r]

# Read each line from the file
while {[gets $file line] != -1} {
    # Split the line into host and IP using the IFS
    set fields [split $line $IFS]
    set host [lindex $fields 0]
    set ip [lindex $fields 1]
    puts "\n"
    puts -nonewline [color_puts "33" "$host "] 
    puts [color_puts "32" "$ip"]
    puts "------------------------------------"
    puts "\n"
    spawn ssh-copy-id $user_admin@$host.local
    expect {
        "Are you sure you want to continue connecting*" {
            send "yes\r"
            exp_continue
        }
        "Password:" {
            send "$pass\r"
            exp_continue
        }
    }
}

# Close the file
close $file
