#!/bin/bash
# This is the main script for installing and configuring everything

############ Initial Setup ############

# assign default variables
DEFAULT_USER="NOUSER"

function show_help {
printf "
Usage: $0 [-h|--help] [-d|--default] [-f|--file <file>]
  -h, --help      Show this help message
  -d, --default   Use default values (automate script)
\n"
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -h|--help)
        show_help
        exit
        ;;
        -d|--default)
        echo "FLAG 1"
        shift
        ;;
        --flag2)
        echo "FLAG 2"
        shift
        ;;
        *)
        echo "Unknown flag: $1"
        shift
        ;;
    esac
done


#echo "Enter your username: (default: NOUSER)"
#read USER
if [ -z "$USER" ]; then
    USERNAME=$DEFAULT_USER
fi

echo "Your username is: $USER"