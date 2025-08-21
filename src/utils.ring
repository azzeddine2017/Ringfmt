/*
	Title :	Ring Code Formatter Utilities
	Date  : 2025.08.12
	Author: Azzeddine
	Description: Advanced utility functions for file handling, validation, and processing
*/

# File handling utilities
func getFileSize cFileName
	try {
		fp = fopen(cFileName, "rb")
		if fp = NULL {
			return 0
		}
		fseek(fp, 0, 2)  # SEEK_END
		nSize = ftell(fp)
		fclose(fp)
		return nSize
	catch
		return 0
	}

func readFileWithEncoding cFileName
	try {
		# Try to detect encoding and read accordingly
		cContent = read(cFileName)
		
		# Check for BOM (Byte Order Mark)
		if len(cContent) >= 3 {
			cBOM = left(cContent, 3)
			if ascii(cBOM[1]) = 239 and ascii(cBOM[2]) = 187 and ascii(cBOM[3]) = 191 {
				# UTF-8 BOM detected, remove it
				cContent = substr(cContent, 4)
			}
		}
		
		return cContent
	catch
		return ""
	}

func writeFileWithEncoding cFileName, cContent
	try {
		write(cFileName, cContent)
		return true
	catch
		return false
	}

# Ring syntax validation
func validateRingSyntax cCode
	
			cTemp = "tempFile.ring"
			write(cTemp, cCode)
			cValidate = systemCmd("ring " + cTemp + " -norun")
			remove(cTemp)
			if cValidate = ""{
					return true
			else
				? "Ring syntax not valid: " + cValidate 
				return false
			}	
			
	

func validateBrackets cCode
	# Validate bracket matching
	nRoundBrackets = 0
	nSquareBrackets = 0
	nCurlyBrackets = 0
	lInString = false
	cStringChar = ""
	
	for i = 1 to len(cCode) {
		cChar = cCode[i]
		
		# Handle strings
		if not lInString and (cChar = '"' or cChar = "'") {
			lInString = true
			cStringChar = cChar
		elseif lInString and cChar = cStringChar
			lInString = false
			cStringChar = ""
		elseif not lInString
			# Count brackets outside strings
			switch cChar {
				case "("
					nRoundBrackets++
				case ")"
					nRoundBrackets--
				case "["
					nSquareBrackets++
				case "]"
					nSquareBrackets--
				case "{"
					nCurlyBrackets++
				case "}"
					nCurlyBrackets--
			}
		}
	}
	
	return nRoundBrackets = 0 and nSquareBrackets = 0 and nCurlyBrackets = 0

func validateQuotes cCode
	# Validate quote matching
	nDoubleQuotes = 0
	nSingleQuotes = 0
	lEscaped = false
	
	for i = 1 to len(cCode) {
		cChar = cCode[i]
		
		if lEscaped {
			lEscaped = false
			loop
		}
		
		if cChar = "\" {
			lEscaped = true
		elseif cChar = '"'
			nDoubleQuotes = 1 - nDoubleQuotes
		elseif cChar = "'"
			nSingleQuotes = 1 - nSingleQuotes
		}
	}
	
	return nDoubleQuotes = 0 and nSingleQuotes = 0

func validateKeywords cCode
	# More flexible keyword validation
	try {
		# Just check for basic syntax patterns
		# Don't be too strict about structure matching

		# Check for obvious syntax errors
		if substr(cCode, "if if") > 0 { return false }
		if substr(cCode, "for for") > 0 { return false }
		if substr(cCode, "while while") > 0 { return false }

		# Check for unmatched quotes in a simple way
		nQuoteCount = 0
		for i = 1 to len(cCode) {
			if cCode[i] = '"' {
				nQuoteCount++
			}
		}

		# Even number of quotes is good enough
		if (nQuoteCount % 2) != 0 { return false }

		return true

	catch
		return false
	}

# Statistics and reporting
func showConversionStats oConverter, cOriginalCode, cConvertedCode
	nOriginalLines = len(str2list(cOriginalCode))
	nConvertedLines = len(str2list(cConvertedCode))
	
	showInfo("Conversion Statistics:")
	showInfo("  Original lines: " + nOriginalLines)
	showInfo("  Converted lines: " + nConvertedLines)
	showInfo("  Size change: " + (len(cConvertedCode) - len(cOriginalCode)) + " characters")

func showConversionLog oConverter
	aLog = oConverter.getConversionLog()
	if len(aLog) > 0 {
		showInfo("Conversion Log:")
		for cMessage in aLog {
			showInfo("  " + cMessage)
		}
	}

# Advanced pattern matching utilities
func findPatternInContext cCode, cPattern, cContext
	# Find pattern within specific context (e.g., inside functions, classes, etc.)
	aMatches = []
	aLines = str2list(cCode)
	lInContext = false
	nContextLevel = 0
	
	for i = 1 to len(aLines) {
		cLine = trim(aLines[i])
		
		# Check for context start
		if cContext = "function" and (left(cLine, 5) = "func " or left(cLine, 4) = "def ") {
			lInContext = true
			nContextLevel = 1
		elseif cContext = "class" and left(cLine, 6) = "class "
			lInContext = true
			nContextLevel = 1
		}
		
		# Track nesting level
		if lInContext {
			if left(cLine, 3) = "if " or left(cLine, 4) = "for " or left(cLine, 6) = "while " {
				nContextLevel++
			elseif cLine = "ok" or cLine = "end" or cLine = "}"
				nContextLevel--
				if nContextLevel = 0 {
					lInContext = false
				}
			}
			
			# Look for pattern in context
			if lInContext and substr(cLine, cPattern) > 0 {
				add(aMatches, [i, cLine])
			}
		}
	}
	
	return aMatches

# Code formatting utilities
func normalizeIndentation cCode, nSpacesPerLevel
	aLines = str2list(cCode)
	aResult = []
	nCurrentLevel = 0
	
	for cLine in aLines {
		cTrimmed = trim(cLine)
		
		# Skip empty lines and comments
		if cTrimmed = "" {
			add(aResult, "")
			loop
		}
		
		if left(cTrimmed, 1) = "#" {
			add(aResult, cLine)
			loop
		}
		
		# Adjust indentation level
		if cTrimmed = "ok" or cTrimmed = "end" or cTrimmed = "next" or cTrimmed = "off" or cTrimmed = "}" {
			nCurrentLevel--
			if nCurrentLevel < 0 { nCurrentLevel = 0 }
		}
		
		# Apply indentation
		cIndent = copy(" ", nCurrentLevel * nSpacesPerLevel)
		add(aResult, cIndent + cTrimmed)
		
		# Increase level for opening structures
		if left(cTrimmed, 3) = "if " or left(cTrimmed, 7) = "elseif " or left(cTrimmed, 5) = "else" or
		   left(cTrimmed, 4) = "for " or left(cTrimmed, 6) = "while " or left(cTrimmed, 7) = "switch " or
		   left(cTrimmed, 5) = "func " or left(cTrimmed, 4) = "def " or left(cTrimmed, 6) = "class " or
		   left(cTrimmed, 4) = "try " or right(cTrimmed, 1) = "{" {
			nCurrentLevel++
		}
	}
	
	return list2str(aResult)

func removeExtraBlankLines cCode
	aLines = str2list(cCode)
	aResult = []
	lPreviousEmpty = false
	
	for cLine in aLines {
		lCurrentEmpty = (trim(cLine) = "")
		
		if not (lCurrentEmpty and lPreviousEmpty) {
			add(aResult, cLine)
		}
		
		lPreviousEmpty = lCurrentEmpty
	}
	
	return list2str(aResult)
