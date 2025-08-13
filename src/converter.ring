/*
	Title :	Ring Language Style Converter - Enhanced Version
	Date  : 2025.08.12
	Author: Azzeddine
	Description: Advanced converter with comprehensive pattern matching and context awareness
*/

class LanguageStyleConverter

	oDetector = null
	aConversionLog = []  # For debugging and reporting
	lDebugMode = false

	func init
		oDetector = new LanguageStyleDetector
		aConversionLog = []

	func convertToStyle cCode, cTargetStyle
		# Enhanced conversion with better error handling and logging
		aConversionLog = []
		cCurrentStyle = oDetector.detectStyle(cCode)
		cTargetStyle = lower(cTargetStyle)

		addLog("Detected current style: " + cCurrentStyle)
		addLog("Target style: " + cTargetStyle)

		# If already in target style, return as-is
		if cCurrentStyle = cTargetStyle {
			addLog("Code already in target style, no conversion needed")
			return cCode
		}

		# Validate and preprocess code
		cCode = preprocessCode(cCode)

		# Convert based on target style
		cResult = ""
		if cTargetStyle = C_STYLE_CLASSIC {
			cResult = convertToClassic(cCode, cCurrentStyle)
		elseif cTargetStyle = C_STYLE_NATURAL
			cResult = convertToNatural(cCode, cCurrentStyle)
		elseif cTargetStyle = C_STYLE_MODERN
			cResult = convertToModern(cCode, cCurrentStyle)
		else
			raise("Unknown target language style: " + cTargetStyle)
		}

		# Post-process and validate result
		cResult = postprocessCode(cResult)
		addLog("Conversion completed successfully")

		return cResult

	func getConversionLog
		return aConversionLog

	func setDebugMode lEnabled
		lDebugMode = lEnabled

	private

		# Core preprocessing and postprocessing
		func preprocessCode cCode
			# Clean and prepare code for conversion
			addLog("Preprocessing code...")

			# Normalize line endings
			cCode = substr(cCode, char(13) + char(10), char(10))  # Windows to Unix
			cCode = substr(cCode, char(13), char(10))  # Mac to Unix

			# Remove only trailing whitespace, preserve leading whitespace (indentation)
			aLines = str2list(cCode)
			for i = 1 to len(aLines) {
				# Only remove trailing whitespace, keep leading spaces
				cLine = aLines[i]
				while len(cLine) > 0 and (right(cLine, 1) = " " or right(cLine, 1) = tab) {
					cLine = left(cLine, len(cLine) - 1)
				}
				aLines[i] = cLine
			}

			return list2str(aLines)

		func postprocessCode cCode
			# Final cleanup and formatting
			addLog("Postprocessing code...")

			aLines = str2list(cCode)
			aCleanLines = []

			for i = 1 to len(aLines) {
				cLine = aLines[i]

				# Remove empty lines at the beginning
				if len(aCleanLines) = 0 and trim(cLine) = "" {
					loop
				}

				# Add the line
				add(aCleanLines, cLine)
			}

			# Remove trailing empty lines
			while len(aCleanLines) > 0 and trim(aCleanLines[len(aCleanLines)]) = "" {
				del(aCleanLines, len(aCleanLines))
			}

			return list2str(aCleanLines)

		func addLog cMessage
			if lDebugMode {
				? "[CONVERTER] " + cMessage
			}
			add(aConversionLog, cMessage)

		func convertToClassic cCode, cFromStyle
			# Convert to classic Ring style
			cResult = cCode
			
			if cFromStyle = C_STYLE_NATURAL {
				cResult = convertNaturalToClassic(cResult)
			elseif cFromStyle = C_STYLE_MODERN
				cResult = convertModernToClassic(cResult)
			}
			
			return cResult
			
		func convertToNatural cCode, cFromStyle
			# Convert to natural Ring style
			cResult = cCode
			
			if cFromStyle = C_STYLE_CLASSIC {
				cResult = convertClassicToNatural(cResult)
			elseif cFromStyle = C_STYLE_MODERN
				cResult = convertModernToNatural(cResult)
			}
			
			return cResult
			
		func convertToModern cCode, cFromStyle
			# Convert to modern Ring style
			cResult = cCode
			
			if cFromStyle = C_STYLE_CLASSIC {
				cResult = convertClassicToModern(cResult)
			elseif cFromStyle = C_STYLE_NATURAL
				cResult = convertNaturalToModern(cResult)
			}
			
			return cResult

		# Simplified Classic to Natural conversion
		func convertClassicToNatural cCode
			addLog("Converting from Classic to Natural style")
			cResult = cCode

			# Simple string replacements
			cResult = substr(cResult, "see ", "put ")
			cResult = substr(cResult, "? ", "put ")
			cResult = substr(cResult, "give ", "get ")
			cResult = substr(cResult, "but ", "elseif ")
			cResult = substr(cResult, " ok", " end")
			cResult = substr(cResult, " next", " end")
			cResult = substr(cResult, " off", " end")
			cResult = substr(cResult, "on ", "case ")

			return cResult

		func convertTokensClassicToNatural aTokens
			aResult = []
			nContext = 0  # 0=normal, 1=in_string, 2=in_comment

			for i = 1 to len(aTokens) {
				oToken = aTokens[i]
				cType = oToken[:type]
				cValue = oToken[:value]
				cOriginal = cValue

				switch cType {
					case "keyword"
						cValue = convertKeywordClassicToNatural(cValue)
					case "io_statement"
						cValue = convertIOClassicToNatural(cValue, oToken[:context])
					case "block_end"
						cValue = convertBlockEndClassicToNatural(cValue, oToken[:context])
					case "identifier"
						# Keep identifiers as-is
					case "operator"
						# Keep operators as-is
					case "string"
						# Keep strings as-is
					case "comment"
						# Keep comments as-is
					case "whitespace"
						# Keep whitespace as-is
				}

				oToken[:value] = cValue
				add(aResult, oToken)
			}

			return reconstructFromTokens(aResult)

		func convertKeywordClassicToNatural cKeyword
			switch cKeyword {
				case "but"
					return "elseif"
				case "on"
					return "case"
				case "other"
					return "other"  # Keep same in natural
				default
					return cKeyword
			}

		func convertIOClassicToNatural cStatement, cContext
			# Handle I/O statements with proper context
			if left(cStatement, 4) = "see " {
				return "put " + substr(cStatement, 5)
			elseif left(cStatement, 2) = "? "
				return "put " + substr(cStatement, 3)
			elseif left(cStatement, 5) = "give "
				return "get " + substr(cStatement, 6)
			else
				return cStatement
			}

		func convertBlockEndClassicToNatural cEnd, cContext
			# Convert block endings based on context
			switch cEnd {
				case "ok"
					return "end"
				case "next"
					return "end"
				case "}"
					return "end"
				default
					return cEnd
			}

		# Advanced tokenization system
		func tokenizeCode cCode
			addLog("Tokenizing code for context-aware conversion")
			aTokens = []
			aLines = str2list(cCode)

			for nLineNum = 1 to len(aLines) {
				cLine = aLines[nLineNum]
				aLineTokens = tokenizeLine(cLine, nLineNum)
				for oToken in aLineTokens {
					add(aTokens, oToken)
				}
			}

			return aTokens

		func tokenizeLine cLine, nLineNum
			aTokens = []
			nPos = 1
			nLen = len(cLine)
			cCurrentToken = ""
			cTokenType = ""
			lInString = false
			cStringChar = ""
			lInComment = false

			while nPos <= nLen {
				cChar = substr(cLine, nPos, 1)

				# Handle comments
				if not lInString and cChar = "#" {
					# Finish current token
					if cCurrentToken != "" {
						add(aTokens, createToken(cTokenType, cCurrentToken, nLineNum, nPos - len(cCurrentToken)))
						cCurrentToken = ""
					}
					# Add rest of line as comment
					cComment = substr(cLine, nPos)
					add(aTokens, createToken("comment", cComment, nLineNum, nPos))
					exit
				}

				# Handle strings
				if not lInComment {
					if not lInString and (cChar = '"' or cChar = "'") {
						# Start of string
						if cCurrentToken != "" {
							add(aTokens, createToken(cTokenType, cCurrentToken, nLineNum, nPos - len(cCurrentToken)))
							cCurrentToken = ""
						}
						lInString = true
						cStringChar = cChar
						cCurrentToken = cChar
						cTokenType = "string"
					elseif lInString and cChar = cStringChar
						# End of string
						cCurrentToken += cChar
						add(aTokens, createToken("string", cCurrentToken, nLineNum, nPos - len(cCurrentToken) + 1))
						cCurrentToken = ""
						lInString = false
						cStringChar = ""
					elseif lInString
						# Inside string
						cCurrentToken += cChar
					else
						# Regular character processing
						if cChar = " " or cChar = tab {
							# Whitespace
							if cCurrentToken != "" {
								add(aTokens, createToken(determineTokenType(cCurrentToken), cCurrentToken, nLineNum, nPos - len(cCurrentToken)))
								cCurrentToken = ""
							}
							# Collect consecutive whitespace
							cWhitespace = ""
							while nPos <= nLen and (substr(cLine, nPos, 1) = " " or substr(cLine, nPos, 1) = tab) {
								cWhitespace += substr(cLine, nPos, 1)
								nPos++
							}
							add(aTokens, createToken("whitespace", cWhitespace, nLineNum, nPos - len(cWhitespace)))
							nPos--  # Adjust for loop increment
						else
							# Regular character
							cCurrentToken += cChar
						}
					}
				}

				nPos++
			}

			# Handle remaining token
			if cCurrentToken != "" {
				add(aTokens, createToken(determineTokenType(cCurrentToken), cCurrentToken, nLineNum, nPos - len(cCurrentToken)))
			}

			# Add newline token
			add(aTokens, createToken("newline", nl, nLineNum, nPos))

			return aTokens

		func createToken cType, cValue, nLine, nColumn
			return [
				:type = cType,
				:value = cValue,
				:line = nLine,
				:column = nColumn,
				:context = determineContext(cType, cValue)
			]

		func determineTokenType cToken
			# Determine token type based on content
			cToken = trim(cToken)

			# Keywords
			aKeywords = ["if", "elseif", "else", "but", "for", "while", "switch", "case", "on", "other", "default",
						 "func", "def", "function", "class", "try", "catch", "return", "break", "continue", "exit", "loop"]
			if find(aKeywords, cToken) > 0 {
				return "keyword"
			}

			# I/O statements
			aIOStatements = ["see", "put", "?", "give", "get", "print", "puts", "getstring"]
			if find(aIOStatements, cToken) > 0 {
				return "io_statement"
			}

			# Block endings
			aBlockEnds = ["ok", "end", "next", "}", "endclass", "endfunc", "endfunction", "endif", "endfor", "endwhile", "endswitch", "endtry"]
			if find(aBlockEnds, cToken) > 0 {
				return "block_end"
			}

			# Operators
			aOperators = ["+", "-", "*", "/", "%", "=", "!=", "<", ">", "<=", ">=", "and", "or", "not", "&", "|", "^"]
			if find(aOperators, cToken) > 0 {
				return "operator"
			}

			# Numbers
			if isnumber(cToken) {
				return "number"
			}

			# Default to identifier
			return "identifier"

		func determineContext cType, cValue
			# Determine context for better conversion decisions
			if cType = "keyword" {
					if cValue = "if" or cValue = "elseif" or cValue = "while" {
						return "conditional"
					elseif cValue =  "for"
						return "loop"
					elseif cValue =  "switch"
						return "switch"
					elseif cValue = "func" or cValue = "def" or cValue = "function"
						return "function_def"
					elseif cValue = "class"
						return "class_def"
					else
						return "general"
				}
			elseif cType = "block_end"
				switch cValue {
					case "next"
						return "loop_end"
					case "}"
						return "switch_end"
					default
						return "general_end"
				}
			}

			return "general"

		func reconstructFromTokens aTokens
			cResult = ""
			for oToken in aTokens {
				cResult += oToken[:value]
			}
			return cResult

	# Simplified Natural to Classic conversion
	func convertNaturalToClassic cCode
		addLog("Converting from Natural to Classic style")
		cResult = cCode

		# Simple string replacements
		cResult = substr(cResult, "put ", "see ")
		cResult = substr(cResult, "get ", "give ")
		cResult = substr(cResult, "elseif ", "but ")
		cResult = substr(cResult, "def ", "func ")
		cResult = substr(cResult, " end", " ok")
		cResult = substr(cResult, "case ", "on ")

		return cResult

	func convertTokensNaturalToClassic aTokens
		aResult = []

		for i = 1 to len(aTokens) {
			oToken = aTokens[i]
			cType = oToken[:type]
			cValue = oToken[:value]

			switch cType {
				case "keyword"
					cValue = convertKeywordNaturalToClassic(cValue)
				case "io_statement"
					cValue = convertIONaturalToClassic(cValue, oToken[:context])
				case "block_end"
					cValue = convertBlockEndNaturalToClassic(cValue, oToken[:context])
			}

			oToken[:value] = cValue
			add(aResult, oToken)
		}

		return reconstructFromTokens(aResult)

	func convertKeywordNaturalToClassic cKeyword
		switch cKeyword {
			case "elseif"
				return "but"
			case "case"
				return "on"
			case "def"
				return "func"
			default
				return cKeyword
		}

	func convertIONaturalToClassic cStatement, cContext
		if left(cStatement, 4) = "put " {
			return "see " + substr(cStatement, 5)
		elseif left(cStatement, 4) = "get "
			return "give " + substr(cStatement, 5)
		else
			return cStatement
		}

	func convertBlockEndNaturalToClassic cEnd, cContext
		switch cEnd {
			case "end"
				if cContext = "loop_end" {
					return "next"
				else
					return "ok"
				}
			default
				return cEnd
		}

	# Simplified Classic to Modern conversion
	func convertClassicToModern cCode
		addLog("Converting from Classic to Modern style")
		cResult = cCode

		# Handle I/O statements first (more complex)
		cResult = convertIOToModernStyle(cResult)

		# Simple keyword replacements
		cResult = substr(cResult, "but ", "elseif ")
		cResult = substr(cResult, "on ", "case ")
		cResult = substr(cResult, "other", "default")
		cResult = substr(cResult, "ok", "}")
		cResult = substr(cResult, "next", "}")
		cResult = substr(cResult, "off", "}")

		# Add braces after control structures
		cResult = addSimpleBraces(cResult)

		return cResult

	func convertIOToModernStyle cCode
		# Convert I/O statements to modern style
		aLines = str2list(cCode)
		aResult = []

		for cLine in aLines {
			cOriginal = cLine
			cTrimmed = trim(cLine)
			cIndent = left(cLine, len(cLine) - len(cTrimmed))

			# Handle 'see' statements
			if substr(cTrimmed, "see ") = 1 {
				cExpression = trim(substr(cTrimmed, 5))  # Remove "see "
				# Don't add extra parentheses if expression already has them
				if left(cExpression, 1) = "(" and right(cExpression, 1) = ")" {
					cTrimmed = "print" + cExpression
				else
					cTrimmed = "print(" + cExpression + ")"
				}
			}

			# Handle '? ' statements
			if substr(cTrimmed, "? ") = 1 {
				cExpression = trim(substr(cTrimmed, 3))  # Remove "? "
				if left(cExpression, 1) = "(" and right(cExpression, 1) = ")" {
					cTrimmed = "puts" + cExpression
				else
					cTrimmed = "puts(" + cExpression + ")"
				}
			}

			# Handle 'give' statements - convert to assignment
			if substr(cTrimmed, "give ") = 1 {
				cVarName = trim(substr(cTrimmed, 6))  # Remove "give "
				cTrimmed = cVarName + " = getstring()"
			}

			add(aResult, cIndent + cTrimmed)
		}

		return list2str(aResult)

	func addSimpleBraces cCode
		# Add braces after control structures in a simple way
		aLines = str2list(cCode)
		aResult = []

		for cLine in aLines {
			cTrimmed = trim(cLine)
			cIndent = left(cLine, len(cLine) - len(cTrimmed))

			# Add braces after control structures
			if left(cTrimmed, 3) = "if " or left(cTrimmed, 6) = "while " or
			   left(cTrimmed, 4) = "for " or left(cTrimmed, 7) = "switch " or
			   left(cTrimmed, 5) = "func " or left(cTrimmed, 6) = "class " {
				if right(cTrimmed, 1) != "{" {
					cTrimmed += " {"
				}
			}

			add(aResult, cIndent + cTrimmed)
		}

		return list2str(aResult)

	func convertTokensClassicToModern aTokens
		aResult = []
		aStructureStack = []  # Track nested structures

		for i = 1 to len(aTokens) {
			oToken = aTokens[i]
			cType = oToken[:type]
			cValue = oToken[:value]

			switch cType {
				case "keyword"
					# Handle control structure keywords
					if cValue = "if" or cValue = "while" or cValue = "for" or cValue = "switch" {
						add(aStructureStack, cValue)
						cValue = convertKeywordClassicToModern(cValue)
						# Add opening brace after the condition
						oToken[:value] = cValue
						add(aResult, oToken)
						# Look ahead to add brace after condition
						addOpeningBraceAfterCondition(aResult, aTokens, i)
						loop
					elseif cValue = "func" or cValue = "class"
						add(aStructureStack, cValue)
						cValue = convertKeywordClassicToModern(cValue)
						oToken[:value] = cValue
						add(aResult, oToken)
						# Add opening brace after function/class signature
						addOpeningBraceAfterSignature(aResult, aTokens, i)
						loop
					else
						cValue = convertKeywordClassicToModern(cValue)
					}
				case "io_statement"
					cValue = convertIOClassicToModern(cValue, oToken[:context], aTokens, i)
				case "block_end"
					cValue = convertBlockEndClassicToModern(cValue, aStructureStack)
			}

			oToken[:value] = cValue
			add(aResult, oToken)
		}

		return reconstructFromTokens(aResult)

	func convertKeywordClassicToModern cKeyword
		switch cKeyword {
			case "but"
				return "elseif"
			case "on"
				return "case"
			case "other"
				return "default"
			default
				return cKeyword
		}

	func convertIOClassicToModern cStatement, cContext, aTokens, nCurrentIndex
		# Enhanced I/O conversion with proper parentheses handling
		if cStatement = "see" {
			return "print"
		elseif cStatement = "?"
			return "puts"
		elseif cStatement = "give"
			return convertGiveToModern(aTokens, nCurrentIndex)
		else
			return cStatement
		}

	func convertGiveToModern aTokens, nCurrentIndex
		# Convert "give varname" to "varname = getstring()"
		# Look ahead to find the variable name
		for i = nCurrentIndex + 1 to len(aTokens) {
			oToken = aTokens[i]
			if oToken[:type] = "identifier" {
				# Found the variable name
				cVarName = oToken[:value]
				# Mark this token for deletion
				oToken[:value] = ""
				oToken[:type] = "deleted"
				# Return the assignment
				return cVarName + " = getstring()"
			elseif oToken[:type] != "whitespace"
				# Stop if we hit something else
				exit
			}
		}
		return "getstring()"

	func convertBlockEndClassicToModern cEnd, aStructureStack
		
		if cEnd = "ok" or cEnd = "next" or cEnd = "}" {
			# Pop from structure stack
			if len(aStructureStack) > 0 {
				del(aStructureStack, len(aStructureStack))
			}
			return "}"
		else
			return cEnd
		}

	func addOpeningBraceAfterCondition aResult, aTokens, nCurrentIndex
		# Add opening brace after finding the condition
		nParenLevel = 0
		lFoundCondition = false

		for i = nCurrentIndex + 1 to len(aTokens) {
			oToken = aTokens[i]
			if oToken[:type] = "newline" and nParenLevel = 0 {
				# Add opening brace before newline
				oBraceToken = createToken("operator", " {", oToken[:line], oToken[:column])
				add(aResult, oBraceToken)
				exit
			}
		}

	func addOpeningBraceAfterSignature aResult, aTokens, nCurrentIndex
		# Add opening brace after function/class signature
		for i = nCurrentIndex + 1 to len(aTokens) {
			oToken = aTokens[i]
			if oToken[:type] = "newline" {
				# Add opening brace before newline
				oBraceToken = createToken("operator", " {", oToken[:line], oToken[:column])
				add(aResult, oBraceToken)
				exit
			}
		}

	# Simplified Natural to Modern conversion
	func convertNaturalToModern cCode
		addLog("Converting from Natural to Modern style")
		cResult = cCode

		# Handle I/O statements with proper conversion
		cResult = convertNaturalIOToModern(cResult)

		# Simple keyword replacements
		cResult = substr(cResult, "def ", "func ")
		cResult = substr(cResult, " end", " }")
		cResult = substr(cResult, "case ", "case ")
		cResult = substr(cResult, "other", "default")

		# Add braces after control structures
		cResult = addSimpleBraces(cResult)

		return cResult

	func convertNaturalIOToModern cCode
		# Convert Natural I/O to Modern style
		aLines = str2list(cCode)
		aResult = []

		for cLine in aLines {
			cTrimmed = trim(cLine)
			cIndent = left(cLine, len(cLine) - len(cTrimmed))

			# Handle 'put' statements
			if substr(cTrimmed, "put ") = 1 {
				cExpression = trim(substr(cTrimmed, 5))  # Remove "put "
				if left(cExpression, 1) = "(" and right(cExpression, 1) = ")" {
					cTrimmed = "print" + cExpression
				else
					cTrimmed = "print(" + cExpression + ")"
				}
			}

			# Handle 'get' statements - convert to assignment
			if substr(cTrimmed, "get ") = 1 {
				cVarName = trim(substr(cTrimmed, 5))  # Remove "get "
				cTrimmed = cVarName + " = getstring()"
			}

			add(aResult, cIndent + cTrimmed)
		}

		return list2str(aResult)

	func convertTokensNaturalToModern aTokens
		aResult = []
		aStructureStack = []

		for i = 1 to len(aTokens) {
			oToken = aTokens[i]
			cType = oToken[:type]
			cValue = oToken[:value]

			switch cType {
				case "keyword"
					if cValue = "if" or cValue = "while" or cValue = "for" or cValue = "switch" {
						add(aStructureStack, cValue)
						oToken[:value] = cValue
						add(aResult, oToken)
						addOpeningBraceAfterCondition(aResult, aTokens, i)
						loop
					elseif cValue = "def"
						cValue = "func"
						add(aStructureStack, cValue)
						oToken[:value] = cValue
						add(aResult, oToken)
						addOpeningBraceAfterSignature(aResult, aTokens, i)
						loop
					elseif cValue = "case"
						cValue = "case"
					}
				case "io_statement"
					cValue = convertIONaturalToModern(cValue, oToken[:context], aTokens, i)
				case "block_end"
					cValue = convertBlockEndNaturalToModern(cValue, aStructureStack)
			}

			oToken[:value] = cValue
			add(aResult, oToken)
		}

		return reconstructFromTokens(aResult)

	func convertIONaturalToModern cStatement, cContext, aTokens, nCurrentIndex
		if cStatement = "put" {
			return "print"
		elseif cStatement = "get"
			return convertGetToModern(aTokens, nCurrentIndex)
		else
			return cStatement
		}

	func convertGetToModern aTokens, nCurrentIndex
		# Convert "get varname" to "varname = getstring()"
		for i = nCurrentIndex + 1 to len(aTokens) {
			oToken = aTokens[i]
			if oToken[:type] = "identifier" {
				cVarName = oToken[:value]
				oToken[:value] = ""
				oToken[:type] = "deleted"
				return cVarName + " = getstring()"
			elseif oToken[:type] != "whitespace"
				exit
			}
		}
		return "getstring()"

	func convertBlockEndNaturalToModern cEnd, aStructureStack
		switch cEnd {
			case "end"
				if len(aStructureStack) > 0 {
					del(aStructureStack, len(aStructureStack))
				}
				return "}"
			default
				return cEnd
		}

	# Helper functions
	func replaceWholeWord cCode, cOldWord, cNewWord
		# Replace whole words only, not parts of other words
		cResult = cCode
		aLines = str2list(cResult)

		for i = 1 to len(aLines) {
			cLine = aLines[i]

			# Simple approach: replace word when it's surrounded by spaces or at line boundaries
			# Handle word at beginning of line
			if left(trim(cLine), len(cOldWord)) = cOldWord {
				cTrimmed = trim(cLine)
				if len(cTrimmed) = len(cOldWord) or
				   substr(cTrimmed, len(cOldWord) + 1, 1) = " " {
					cIndent = left(cLine, len(cLine) - len(trim(cLine)))
					cRest = substr(cTrimmed, len(cOldWord) + 1)
					aLines[i] = cIndent + cNewWord + cRest
				}
			}

			# Handle word in middle or end of line
			nPos = substr(cLine, " " + cOldWord + " ")
			if nPos > 0 {
				cBefore = left(cLine, nPos)
				cAfter = substr(cLine, nPos + len(cOldWord) + 1)
				aLines[i] = cBefore + cNewWord + cAfter
			}

			# Handle word at end of line
			if right(trim(cLine), len(cOldWord) + 1) = " " + cOldWord {
				cTrimmed = trim(cLine)
				cIndent = left(cLine, len(cLine) - len(cTrimmed))
				cBefore = left(cTrimmed, len(cTrimmed) - len(cOldWord))
				aLines[i] = cIndent + cBefore + cNewWord
			}
		}

		return list2str(aLines)

	func replaceBlockEndings cCode, cOldEnding, cNewEnding
		# Replace block endings like ok -> end or end -> }
		cResult = cCode
		aLines = str2list(cResult)

		for i = 1 to len(aLines) {
			cLine = trim(aLines[i])

			# Check if line is just the ending keyword
			if cLine = cOldEnding {
				cIndent = left(aLines[i], len(aLines[i]) - len(trim(aLines[i])))
				aLines[i] = cIndent + cNewEnding
			}
		}

		return list2str(aLines)

	func replaceLoopEndings cCode, cNewEnding
		# Replace loop endings specifically (for classic style)
		# This is a simplified version - in reality we'd need to track context
		cResult = cCode
		# For now, just replace 'end' with 'next' in loop contexts
		# This would need more sophisticated parsing in a real implementation
		return cResult

	func addBracesForControlStructures cCode
		# Add opening braces for if, while, for, switch, func statements
		cResult = cCode
		aLines = str2list(cResult)

		for i = 1 to len(aLines) {
			cLine = trim(aLines[i])

			# Check for control structures that need braces
			if (left(cLine, 3) = "if " or left(cLine, 7) = "elseif " or
			    left(cLine, 6) = "while " or left(cLine, 4) = "for " or
			    left(cLine, 7) = "switch " or left(cLine, 5) = "func " or
			    left(cLine, 6) = "class ") and not (right(cLine, 1) = "{") {

				# Add opening brace
				cIndent = left(aLines[i], len(aLines[i]) - len(trim(aLines[i])))
				aLines[i] = cIndent + cLine + " {"
			}
		}

		return list2str(aLines)

	func convertIOToModern cCode
		# Convert see/put statements to print() and give/get to getstring()
		cResult = cCode
		aLines = str2list(cResult)

		for i = 1 to len(aLines) {
			cLine = aLines[i]

			# Handle 'see ' statements
			if substr(cLine, "see ") > 0 {
				nPos = substr(cLine, "see ")
				cBefore = left(cLine, nPos - 1)
				cAfter = substr(cLine, nPos + 4)  # Skip "see "

				# Find the end of the expression (before comment if any)
				nCommentPos = substr(cAfter, "#")
				if nCommentPos > 0 {
					cExpression = trim(left(cAfter, nCommentPos - 1))
					cComment = substr(cAfter, nCommentPos)
					aLines[i] = cBefore + "print(" + cExpression + ")" + " " + cComment
				else
					aLines[i] = cBefore + "print(" + trim(cAfter) + ")"
				}
			}

			# Handle 'put ' statements
			if substr(cLine, "put ") > 0 {
				nPos = substr(cLine, "put ")
				cBefore = left(cLine, nPos - 1)
				cAfter = substr(cLine, nPos + 4)  # Skip "put "

				# Find the end of the expression (before comment if any)
				nCommentPos = substr(cAfter, "#")
				if nCommentPos > 0 {
					cExpression = trim(left(cAfter, nCommentPos - 1))
					cComment = substr(cAfter, nCommentPos)
					aLines[i] = cBefore + "print(" + cExpression + ")" + " " + cComment
				else
					aLines[i] = cBefore + "print(" + trim(cAfter) + ")"
				}
			}

			# Handle '? ' statements
			if substr(cLine, "? ") > 0 {
				nPos = substr(cLine, "? ")
				cBefore = left(cLine, nPos - 1)
				cAfter = substr(cLine, nPos + 2)  # Skip "? "

				# Find the end of the expression (before comment if any)
				nCommentPos = substr(cAfter, "#")
				if nCommentPos > 0 {
					cExpression = trim(left(cAfter, nCommentPos - 1))
					cComment = substr(cAfter, nCommentPos)
					aLines[i] = cBefore + "puts(" + cExpression + ")" + " " + cComment
				else
					aLines[i] = cBefore + "puts(" + trim(cAfter) + ")"
				}
			}

			# Handle 'give ' and 'get ' statements
			if substr(cLine, "give ") > 0 {
				nPos = substr(cLine, "give ")
				cBefore = left(cLine, nPos - 1)
				cAfter = substr(cLine, nPos + 5)  # Skip "give "
				cVarName = trim(cAfter)
				aLines[i] = cBefore + cVarName + " = getstring()"
			}
			if substr(cLine, "get ") > 0 {
				nPos = substr(cLine, "get ")
				cBefore = left(cLine, nPos - 1)
				cAfter = substr(cLine, nPos + 4)  # Skip "get "
				cVarName = trim(cAfter)
				aLines[i] = cBefore + cVarName + " = getstring()"
			}
		}

		return list2str(aLines)

	# Additional helper functions for missing conversions
	func convertIOFromModern cCode
		# Convert print() and puts() back to see/give
		cResult = cCode
		# Simple implementation - would need more sophisticated parsing
		cResult = substr(cResult, "print(", "see ")
		cResult = substr(cResult, "puts(", "? ")
		cResult = substr(cResult, "getstring()", "give ")
		return cResult

	func convertIOFromModernToNatural cCode
		# Convert print() and puts() to put/get
		cResult = cCode
		cResult = substr(cResult, "print(", "put ")
		cResult = substr(cResult, "puts(", "put ")
		cResult = substr(cResult, "getstring()", "get ")
		return cResult

	func removeBracesAndConvertEndings cCode
		# Remove braces and convert to classic endings
		cResult = cCode
		cResult = substr(cResult, " {", "")
		cResult = substr(cResult, "{", "")
		cResult = replaceBlockEndings(cResult, "}", "ok")
		return cResult

	func removeBracesAndConvertToNatural cCode
		# Remove braces and convert to natural endings
		cResult = cCode
		cResult = substr(cResult, " {", "")
		cResult = substr(cResult, "{", "")
		cResult = replaceBlockEndings(cResult, "}", "end")
		return cResult

	# Enhanced Modern to Classic conversion
	func convertModernToClassic cCode
		addLog("Converting from Modern to Classic style")
		cResult = cCode

		# Convert I/O statements first
		cResult = convertModernIOToClassic(cResult)

		# Simple keyword replacements
		cResult = substr(cResult, "elseif ", "but ")
		cResult = substr(cResult, "case", "on")
		cResult = substr(cResult, "default", "other")
		cResult = substr(cResult, "break", "exit")
		cResult = substr(cResult, "continue", "loop")

		# Remove braces and convert to classic endings
		cResult = removeBracesSimple(cResult)

		return cResult

	func convertModernIOToClassic cCode
		# Convert Modern I/O to Classic style
		aLines = str2list(cCode)
		aResult = []

		for cLine in aLines {
			cTrimmed = trim(cLine)
			cIndent = left(cLine, len(cLine) - len(cTrimmed))

			# Handle 'print(' statements
			if substr(cTrimmed, "print(") = 1 {
				# Extract content between parentheses
				nStart = substr(cTrimmed, "(")
				nEnd = 0
				for i = len(cTrimmed) to 1 step -1 {
					if cTrimmed[i] = ")" {
						nEnd = i
						exit
					}
				}
				if nEnd > nStart {
					cExpression = substr(cTrimmed, nStart + 1, nEnd - nStart - 1)
					cTrimmed = "see " + cExpression
				}
			}

			# Handle 'puts(' statements
			if substr(cTrimmed, "puts(") = 1 {
				nStart = substr(cTrimmed, "(")
				nEnd = 0
				for i = len(cTrimmed) to 1 step -1 {
					if cTrimmed[i] = ")" {
						nEnd = i
						exit
					}
				}
				if nEnd > nStart {
					cExpression = substr(cTrimmed, nStart + 1, nEnd - nStart - 1)
					cTrimmed = "? " + cExpression
				}
			}

			# Handle assignment with getstring()
			if substr(cTrimmed, " = getstring()") > 0 {
				nPos = substr(cTrimmed, " = getstring()")
				cVarName = trim(left(cTrimmed, nPos - 1))
				cTrimmed = "give " + cVarName
			}

			add(aResult, cIndent + cTrimmed)
		}

		return list2str(aResult)

	func removeBracesSimple cCode
		# Simple brace removal and conversion to classic endings
		cResult = cCode
		cResult = substr(cResult, " {", "")
		cResult = substr(cResult, "{", "")
		cResult = substr(cResult, " }", " ok")
		cResult = substr(cResult, "}", "ok")
		return cResult

	func convertTokensModernToClassic aTokens
		aResult = []
		aStructureStack = []

		for i = 1 to len(aTokens) {
			oToken = aTokens[i]
			cType = oToken[:type]
			cValue = oToken[:value]

			switch cType {
				case "keyword"
					cValue = convertKeywordModernToClassic(cValue)
				case "io_statement"
					cValue = convertIOModernToClassic(cValue, oToken[:context], aTokens, i)
				case "operator"
					if cValue = "{" {
						# Remove opening brace
						oToken[:value] = ""
						oToken[:type] = "deleted"
					elseif cValue = "}"
						# Convert closing brace to appropriate ending
						cValue = convertClosingBraceToClassic(aStructureStack)
					}
				case "block_end"
					if cValue = "}" {
						cValue = convertClosingBraceToClassic(aStructureStack)
					}
			}

			oToken[:value] = cValue
			add(aResult, oToken)
		}

		return reconstructFromTokens(aResult)

	func convertKeywordModernToClassic cKeyword
		switch cKeyword {
			case "elseif"
				return "but"
			case "case"
				return "on"
			case "default"
				return "other"
			case "break"
				return "exit"
			case "continue"
				return "loop"
			default
				return cKeyword
		}

	func convertIOModernToClassic cStatement, cContext, aTokens, nCurrentIndex
		if cStatement = "print" {
			return "see"
		elseif cStatement = "puts"
			return "?"
		else
			return cStatement
		}

	func convertClosingBraceToClassic aStructureStack
		# Determine appropriate ending based on structure stack
		if len(aStructureStack) > 0 {
			cStructure = aStructureStack[len(aStructureStack)]
			del(aStructureStack, len(aStructureStack))

			
			if cStructure = "for" or cStructure = "while" {
				return "next"
			elseif cStructure = "switch" or cStructure = "case"
				return "}"
			else
				return "ok"
			}
		}
		return "ok"

	# Enhanced Modern to Natural conversion
	func convertModernToNatural cCode
		addLog("Converting from Modern to Natural style")
		cResult = cCode

		# Convert I/O statements first
		cResult = convertModernIOToNatural(cResult)

		# Simple keyword replacements
		cResult = substr(cResult, "case", "case")
		cResult = substr(cResult, "default", "other")
		cResult = substr(cResult, "func ", "def ")
		cResult = substr(cResult, "break", "exit")
		cResult = substr(cResult, "continue", "loop")

		# Remove braces and convert to natural endings
		cResult = removeBracesToNatural(cResult)

		return cResult

	func convertModernIOToNatural cCode
		# Convert Modern I/O to Natural style
		aLines = str2list(cCode)
		aResult = []

		for cLine in aLines {
			cTrimmed = trim(cLine)
			cIndent = left(cLine, len(cLine) - len(cTrimmed))

			# Handle 'print(' statements
			if substr(cTrimmed, "print(") = 1 {
				nStart = substr(cTrimmed, "(")
				nEnd = 0
				for i = len(cTrimmed) to 1 step -1 {
					if cTrimmed[i] = ")" {
						nEnd = i
						exit
					}
				}
				if nEnd > nStart {
					cExpression = substr(cTrimmed, nStart + 1, nEnd - nStart - 1)
					cTrimmed = "put " + cExpression
				}
			}

			# Handle 'puts(' statements
			if substr(cTrimmed, "puts(") = 1 {
				nStart = substr(cTrimmed, "(")
				nEnd = 0
				for i = len(cTrimmed) to 1 step -1 {
					if cTrimmed[i] = ")" {
						nEnd = i
						exit
					}
				}
				if nEnd > nStart {
					cExpression = substr(cTrimmed, nStart + 1, nEnd - nStart - 1)
					cTrimmed = "put " + cExpression
				}
			}

			# Handle assignment with getstring()
			if substr(cTrimmed, " = getstring()") > 0 {
				nPos = substr(cTrimmed, " = getstring()")
				cVarName = trim(left(cTrimmed, nPos - 1))
				cTrimmed = "get " + cVarName
			}

			add(aResult, cIndent + cTrimmed)
		}

		return list2str(aResult)

	func removeBracesToNatural cCode
		# Remove braces and convert to natural endings
		cResult = cCode
		cResult = substr(cResult, " {", "")
		cResult = substr(cResult, "{", "")
		cResult = substr(cResult, " }", " end")
		cResult = substr(cResult, "}", "end")
		return cResult

	func convertTokensModernToNatural aTokens
		aResult = []
		aStructureStack = []

		for i = 1 to len(aTokens) {
			oToken = aTokens[i]
			cType = oToken[:type]
			cValue = oToken[:value]

			switch cType {
				case "keyword"
					cValue = convertKeywordModernToNatural(cValue)
				case "io_statement"
					cValue = convertIOModernToNatural(cValue, oToken[:context], aTokens, i)
				case "operator"
					if cValue = "{" {
						# Remove opening brace
						oToken[:value] = ""
						oToken[:type] = "deleted"
					elseif cValue = "}"
						# Convert closing brace to end
						cValue = "end"
					}
				case "block_end"
					if cValue = "}" {
						cValue = "end"
					}
			}

			oToken[:value] = cValue
			add(aResult, oToken)
		}

		return reconstructFromTokens(aResult)

	func convertKeywordModernToNatural cKeyword
		switch cKeyword {
			case "case"
				return "case"
			case "default"
				return "other"
			case "func"
				return "def"
			case "break"
				return "exit"
			case "continue"
				return "loop"
			default
				return cKeyword
		}

	func convertIOModernToNatural cStatement, cContext, aTokens, nCurrentIndex
		if cStatement = "print" {
			return "put"
		elseif cStatement = "puts"
			return "put"
		else
			return cStatement
		}
