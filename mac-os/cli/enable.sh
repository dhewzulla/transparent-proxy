sudo pfctl -e


# Edit the file /etc/sudoers on your system as root. Add the following line to the end of the file:

# ALL ALL=NOPASSWD: /sbin/pfctl -s state