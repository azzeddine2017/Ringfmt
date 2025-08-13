/*
	Title :	Ring Code Formatter Globals
	Date  : 2025.01.12
	Author: Azzeddine
*/

# Global Variables
	aCommand = []		# Command line parameters
	
# Constants
	C_PROGRAM_NAME = "RingFmt"
	C_PROGRAM_VERSION = "1.0.0"
	C_PROGRAM_AUTHOR = "Azzeddine"
	C_PROGRAM_DESCRIPTION = "Ring Code Formatter - Format Ring code with different language styles"
	
# Error Messages
	C_ERROR_NOFILE = "Error: No input file specified!"
	C_ERROR_FILENOTFOUND = "Error: Input file not found!"
	C_ERROR_INVALIDSTYLE = "Error: Invalid target style specified!"
	C_ERROR_CANNOTREAD = "Error: Cannot read input file!"
	C_ERROR_CANNOTWRITE = "Error: Cannot write output file!"
	
# Success Messages
	C_SUCCESS_FORMATTED = "Code formatted successfully!"
	C_SUCCESS_DETECTED = "Style detected:"
	
# Available Styles
	C_STYLE_CLASSIC = "classic"
	C_STYLE_NATURAL = "natural" 
	C_STYLE_MODERN = "modern"
	
	aAvailableStyles = [C_STYLE_CLASSIC, C_STYLE_NATURAL, C_STYLE_MODERN]
