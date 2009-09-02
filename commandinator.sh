#!/bin/bash

VERSION="0.1.1"
ONELINE_USAGE="$0 application_name application_executable [exit_string]"

HISTORY_BASE="$HOME/.commandinator_history"

version()
{
	sed -e 's/^    //' <<EndVersion
   Commandinator v$VERSION

   First release: 02/07/2009
   Author: Dyson Simmons
   License: GPL, http://www.gnu.org/copyleft/gpl.html
EndVersion
	exit 1
}

usage()
{
	sed -e 's/^    //' <<EndUsage
   Usage: $ONELINE_USAGE
   Try '$0 -h' for more information.
EndUsage
    exit 1
}

help()
{
    sed -e 's/^    //' <<EndHelp
   Usage: $ONELINE_USAGE

   Application Name:
   The name you want to appear in the command line.

   Application Executable:
   The command to continually execute.

   Exit String:
   The string used to exit Continuous Commander.
   Default: exit
EndHelp
    exit 1
}

hash()
{
	echo "$@" | openssl md5 | cut -f1 -d' '
}

while getopts "hv" option
do
	case $option in
		h )
			help
			;;
		v )
			version
			;;
	esac
done

if [ $# -lt 2 ]
then
    usage
fi

application_name=$1
application_executable=$2
exit_command=${3:-exit}

mkdir -p "$HISTORY_BASE"

HISTORY="$HISTORY_BASE/$(hash $(pwd))_$application_name"
history -r $HISTORY 

user_command=""

while true
do
	read -ep "$application_name> " user_command
	history -s "$user_command"
	if [ "$user_command" != "$exit_command" ]
	then
		eval "$application_executable $user_command"
	else
		history -w $HISTORY
		exit 1
	fi
done
