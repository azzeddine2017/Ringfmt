/*
	Title :	Ring Code Formatter (RingFmt)
	Date  : 2025.01.12
	Author: Azzeddine
	Description: A command-line tool for formatting Ring code with different language styles
*/

# Load Global Libraries 
	load "stdlibcore.ring"
	
# Load Application Files 
	load "src/core.ring"

func Main
	aCommand = getParameters("ringfmt")
	cCurrentDir = currentdir()

	# Show title and commands if no parameters
	if len(aCommand) = 0 {
		showTitle()
		showCommands()
	else
		# Execute commands
		executeCommands()
	}

	# Restore directory
	chdir(cCurrentDir)


