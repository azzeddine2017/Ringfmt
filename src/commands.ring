/*
	Title :	Ring Code Formatter Commands
	Date  : 2025.08.12
	Author: Azzeddine
*/

func executeCommands
	# Enhanced command execution with comprehensive error handling

	# Check if we have at least one parameter
	if len(aCommand) < 1 {
		showError("No input file specified!")
		showInfo("Use 'ringfmt -help' for usage information.")
		return
	}

	# Check for help command
	if find(aCommand, "-help") or find(aCommand, "--help") or find(aCommand, "-h") {
		showTitle()
		showCommands()
		return
	}

	# Check for version command
	if find(aCommand, "-version") or find(aCommand, "--version") or find(aCommand, "-v") {
		showTitle()
		return
	}

	# Get input file (first parameter)
	cInputFile = aCommand[1]

	# Validate input file
	if not validateInputFile(cInputFile) {
		return
	}

	# Check for detect-only mode
	if find(aCommand, "-detect") {
		detectAndShowStyle(cInputFile)
		return
	}

	# Check for validate-only mode
	if find(aCommand, "-validate") {
		validateAndShowResults(cInputFile)
		return
	}

	# Check for format-only mode (normalize indentation without style conversion)
	if find(aCommand, "-format") {
		formatOnly(cInputFile)
		return
	}

	# Get target style
	cTargetStyle = getTargetStyle()
	if cTargetStyle = "" {
		showError("No target style specified!")
		showInfo("Available styles: -classic, -natural, -modern")
		showInfo("Other options: -detect, -validate, -format")
		return
	}

	# Get output file
	cOutputFile = getOutputFile(cInputFile)

	# Format the code
	formatCode(cInputFile, cOutputFile, cTargetStyle)

func getTargetStyle
	if find(aCommand, "-classic") {
		return C_STYLE_CLASSIC
	elseif find(aCommand, "-natural")
		return C_STYLE_NATURAL
	elseif find(aCommand, "-modern")
		return C_STYLE_MODERN
	else
		return ""
	}

func getOutputFile cInputFile
	nOutputIndex = find(aCommand, "-output")
	if nOutputIndex > 0 and nOutputIndex < len(aCommand) {
		return aCommand[nOutputIndex + 1]
	else
		return cInputFile  # Overwrite input file
	}

func detectAndShowStyle cInputFile
	try {
		cCode = read(cInputFile)
		oDetector = new LanguageStyleDetector
		cDetectedStyle = oDetector.detectStyle(cCode)
		
		showInfo("File: " + cInputFile)
		showInfo("Detected style: " + cDetectedStyle)
		
		# Show style characteristics
		showStyleInfo(cDetectedStyle)
		
	catch
		showError("Cannot read file: " + cInputFile)
	}

func showStyleInfo cStyle
	switch cStyle {
		case C_STYLE_CLASSIC
			? "  - Uses 'see' and 'give' for I/O"
			? "  - Uses 'ok' to end blocks"
			? "  - Uses 'but' instead of 'elseif'"
			? "  - Uses 'next' to end loops"
		case C_STYLE_NATURAL
			? "  - Uses 'put' and 'get' for I/O"
			? "  - Uses 'end' to end blocks"
			? "  - Uses 'def' for function definitions"
			? "  - Supports try-catch blocks"
		case C_STYLE_MODERN
			? "  - Uses 'print()' and 'getstring()' for I/O"
			? "  - Uses braces {} for blocks"
			? "  - C-like syntax style"
			? "  - Modern error handling"
	}

func formatCode cInputFile, cOutputFile, cTargetStyle
	try {
		# Validate input file
		if not fexists(cInputFile) {
			showError("Input file does not exist: " + cInputFile)
			return
		}

		# Check file size (avoid processing very large files)
		nFileSize = getFileSize(cInputFile)
		if nFileSize > 10485760 {  # 10MB limit
			showError("File too large (>10MB). Please split into smaller files.")
			return
		}

		# Read input file with encoding detection
		cCode = readFileWithEncoding(cInputFile)
		if cCode = "" {
			showError("Could not read file or file is empty: " + cInputFile)
			return
		}

		# Validate Ring syntax before conversion
		if not validateRingSyntax(cCode) {
			showError("Input file contains syntax errors. Please fix before formatting.")
			return
		}

		# Create converter with debug mode if needed
		oConverter = new LanguageStyleConverter()
		if find(aCommand, "-debug") > 0 {
			oConverter.setDebugMode(true)
		}

		# Detect current style and show info
		cCurrentStyle = oConverter.oDetector.detectStyle(cCode)
		showInfo("Detected current style: " + cCurrentStyle)

		# Check if conversion is needed
		if cCurrentStyle = cTargetStyle {
			showInfo("Code is already in target style. No conversion needed.")
			if cInputFile != cOutputFile {
				# Still copy to output file if different
				write(cOutputFile, cCode)
			}
			return
		}

		# Perform conversion
		showInfo("Converting from " + cCurrentStyle + " to " + cTargetStyle + "...")
		cFormattedCode = oConverter.convertToStyle(cCode, cTargetStyle)

		# Validate result
		if not validateRingSyntax(cFormattedCode) {
			showError("Conversion resulted in invalid syntax. Please report this issue.")
			showInfo("Original file preserved.")
			return
		}

		# Create backup if overwriting
		if cInputFile = cOutputFile {
			cBackupFile = cInputFile + ".backup"
			write(cBackupFile, cCode)
			showInfo("Backup created: " + cBackupFile)
		}

		# Write output file
		writeFileWithEncoding(cOutputFile, cFormattedCode)

		# Show conversion statistics
		showConversionStats(oConverter, cCode, cFormattedCode)

		showSuccess("Code formatted successfully!")
		showInfo("Input file: " + cInputFile)
		showInfo("Output file: " + cOutputFile)
		showInfo("Target style: " + cTargetStyle)

		# Show conversion log if debug mode
		if find(aCommand, "-debug") > 0 {
			showConversionLog(oConverter)
		}

	catch
		showError("Error processing file: " + cCatchError)
		showInfo("Please check file permissions and syntax.")
	}

func validateInputFile cInputFile
	# Comprehensive input file validation

	# Check if file exists
	if not fexists(cInputFile) {
		showError("Input file '" + cInputFile + "' not found!")
		return false
	}

	# Check file extension
	cExt = lower(right(cInputFile, 5))
	if cExt != ".ring" {
		showWarning("File does not have .ring extension. Proceeding anyway...")
	}

	# Check file size
	nFileSize = getFileSize(cInputFile)
	if nFileSize = 0 {
		showError("Input file is empty or cannot be read!")
		return false
	}

	if nFileSize > 10485760 {  # 10MB limit
		showError("File too large (>10MB). Please split into smaller files.")
		return false
	}

	return true

func validateAndShowResults cInputFile
	try {
		cCode = readFileWithEncoding(cInputFile)

		showInfo("Validating Ring syntax in: " + cInputFile)

		if validateRingSyntax(cCode) {
			showSuccess("File syntax is valid!")
		else
			showError("File contains syntax errors!")
		}

		# Show additional file statistics
		aLines = str2list(cCode)
		nTotalLines = len(aLines)
		nCodeLines = 0
		nCommentLines = 0
		nEmptyLines = 0

		for cLine in aLines {
			cTrimmed = trim(cLine)
			if cTrimmed = "" {
				nEmptyLines++
			elseif left(cTrimmed, 1) = "#"
				nCommentLines++
			else
				nCodeLines++
			}
		}

		showInfo("File Statistics:")
		showInfo("  Total lines: " + nTotalLines)
		showInfo("  Code lines: " + nCodeLines)
		showInfo("  Comment lines: " + nCommentLines)
		showInfo("  Empty lines: " + nEmptyLines)
		showInfo("  File size: " + getFileSize(cInputFile) + " bytes")

	catch
		showError("Error validating file: " + cCatchError)
	}
