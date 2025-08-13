/*
	Title :	Ring Code Formatter Console Interface
	Date  : 2025.01.12
	Author: Azzeddine
*/

func showTitle
	line75()
	? C_PROGRAM_NAME + " v" + C_PROGRAM_VERSION
	? C_PROGRAM_DESCRIPTION
	? "Author: " + C_PROGRAM_AUTHOR
	line75()

func showCommands
	? "Usage: ringfmt <input_file> [options]"
	? ""
	? "Style Conversion Options:"
	? "  -classic     Convert to Classic Ring style (see/give, func...ok)"
	? "  -natural     Convert to Natural Modified style (put/get, def...end)"
	? "  -modern      Convert to Modern C-like style (print(), func{})"
	? ""
	? "Analysis Options:"
	? "  -detect      Only detect and show the current style"
	? "  -validate    Validate Ring syntax and show file statistics"
	? ""
	? "Formatting Options:"
	? "  -format      Format code (normalize indentation, remove extra blank lines)"
	? "  -indent <n>  Set indentation spaces (1-8, default: 4)"
	? ""
	? "Output Options:"
	? "  -output <file>  Specify output file (default: overwrite input)"
	? "  -force       Force conversion even with syntax errors"
	? ""
	? "Debug Options:"
	? "  -debug       Show detailed conversion process"
	? ""
	? "General Options:"
	? "  -help        Show this help message"
	? "  -version     Show version information"
	? ""
	? "Examples:"
	? "  ringfmt mycode.ring -modern"
	? "  ringfmt mycode.ring -classic -output formatted.ring"
	? "  ringfmt mycode.ring -detect"
	? "  ringfmt mycode.ring -validate"
	? "  ringfmt mycode.ring -format -indent 2"
	? "  ringfmt mycode.ring -modern -debug"
	line75()

func line75
	? copy("=", 75)

func showError cMessage
	? "ERROR: " + cMessage

func showSuccess cMessage
	? "SUCCESS: " + cMessage

func showInfo cMessage
	? "INFO: " + cMessage

func showWarning cMessage
	? "WARNING: " + cMessage
