#!/bin/bash

#System Information

#To generate hostname
HOSTNAME=$(hostname)

#To get the OS Information
OS=$(source /etc/os-release)

#To get the system uptime
UPTIME=$(uptime -p)




#The output report directly to the terminal
cat <<EOF


System Report generated by $(USER),$(date)

System Information
------------------

System Information
------------------
Hostname: $HOSTNAME
OS: $OS
Uptime: $UPTIME


EOF
