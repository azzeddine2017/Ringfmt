/*
	Title :	Ring Language Style Detector
	Date  : 2025.08.12
	Author: Azzeddine
	Description: Automatically detects the current language style of Ring code
*/

class LanguageStyleDetector

	func detectStyle cCode
		# Enhanced style detection with better accuracy
		nClassicScore = 0
		nNaturalScore = 0
		nModernScore = 0

		aLines = str2list(cCode)

		for cLine in aLines {
			cOriginalLine = cLine
			cLine = trim(cLine)

			# Skip empty lines and comments
			if cLine = "" or left(cLine, 1) = "#" {
				loop
			}

			# Remove string literals to avoid false positives
			cLineNoStrings = removeStringLiterals(cLine)

			# Check for Classic style indicators (higher weight for unique patterns)
			if isWordBoundary(cLineNoStrings, "see ") { nClassicScore += 3 }
			if isWordBoundary(cLineNoStrings, "? ") { nClassicScore += 3 }
			if isWordBoundary(cLineNoStrings, "give ") { nClassicScore += 3 }
			if isWordBoundary(cLineNoStrings, "but ") { nClassicScore += 4 }  # Very specific to classic
			if isLineEnding(cLine, "ok") { nClassicScore += 4 }
			if isLineEnding(cLine, "next") { nClassicScore += 3 }
			if isLineEnding(cLine, "off") { nClassicScore += 3 }
			if isWordBoundary(cLineNoStrings, "on ") and not isWordBoundary(cLineNoStrings, "function") { nClassicScore += 2 }

			# Check for Natural style indicators
			if isWordBoundary(cLineNoStrings, "put ") { nNaturalScore += 3 }
			if isWordBoundary(cLineNoStrings, "get ") { nNaturalScore += 3 }
			if isWordBoundary(cLineNoStrings, "def ") { nNaturalScore += 4 }  # Very specific to natural
			if isLineEnding(cLine, "end") { nNaturalScore += 3 }
			if isWordBoundary(cLineNoStrings, "elseif ") { nNaturalScore += 2 }
			if isWordBoundary(cLineNoStrings, "case ") and not substr(cLineNoStrings, "case ") > 0 { nNaturalScore += 2 }
			if substr(cLineNoStrings, "try") > 0 and not substr(cLineNoStrings, "try {") > 0 { nNaturalScore += 2 }

			# Check for Modern style indicators
			if substr(cLineNoStrings, "print(") > 0 { nModernScore += 3 }
			if substr(cLineNoStrings, "puts(") > 0 { nModernScore += 3 }
			if substr(cLineNoStrings, "getstring()") > 0 { nModernScore += 3 }
			if substr(cLineNoStrings, "case") > 0 { nModernScore += 4 }  # Very specific to modern
			if substr(cLineNoStrings, "default") > 0 { nModernScore += 4 }
			if substr(cLineNoStrings, "try {") > 0 { nModernScore += 3 }
			if substr(cLineNoStrings, "break") > 0 { nModernScore += 2 }
			if substr(cLineNoStrings, "continue") > 0 { nModernScore += 2 }

			# Check for braces (strong indicator of modern style)
			if right(trim(cOriginalLine), 1) = "{" { nModernScore += 4 }
			if trim(cOriginalLine) = "}" { nModernScore += 4 }
		}

		# Add debug information
		 ? "Detection scores - Classic: " + nClassicScore + ", Natural: " + nNaturalScore + ", Modern: " + nModernScore

		# Determine style based on highest score with minimum threshold
		if nClassicScore >= nNaturalScore and nClassicScore >= nModernScore and nClassicScore > 0 {
			return C_STYLE_CLASSIC
		elseif nNaturalScore >= nModernScore and nNaturalScore > 0
			return C_STYLE_NATURAL
		elseif nModernScore > 0
			return C_STYLE_MODERN
		else
			# Default to classic if no clear indicators
			return C_STYLE_CLASSIC
		}

	# Helper functions for better detection
	func removeStringLiterals cLine
		# Simple string literal removal (handles basic cases)
		cResult = cLine
		nInString = 0
		cQuote = ""
		cNewLine = ""

		for i = 1 to len(cLine) {
			cChar = cLine[i]
			if nInString = 0 {
				if cChar = '"' or cChar = "'" {
					nInString = 1
					cQuote = cChar
					cNewLine += " "  # Replace with space
				else
					cNewLine += cChar
				}
			else
				if cChar = cQuote {
					nInString = 0
					cQuote = ""
				}
				cNewLine += " "  # Replace string content with spaces
			}
		}

		return cNewLine

	func isWordBoundary cLine, cWord
		# Check if word appears with proper boundaries
		nPos = substr(cLine, cWord)
		if nPos = 0 { return false }

		# Check character before word
		if nPos > 1 {
			cBefore = substr(cLine, nPos - 1, 1)
			if not (cBefore = " " or cBefore = tab or cBefore = "(" or cBefore = "{") {
				return false
			}
		}

		# Check character after word
		nAfterPos = nPos + len(cWord)
		if nAfterPos <= len(cLine) {
			cAfter = substr(cLine, nAfterPos, 1)
			if not (cAfter = " " or cAfter = tab or cAfter = "(" or cAfter = "{" or cAfter = "" or cAfter = nl) {
				return false
			}
		}

		return true

	func isLineEnding cLine, cWord
		# Check if word appears at the end of line
		cTrimmed = trim(cLine)
		return right(cTrimmed, len(cWord)) = cWord
