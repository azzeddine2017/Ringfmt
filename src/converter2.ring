/* Title : Ring Language Style Converter - Enhanced Version
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
        cCode = substr(cCode, char(13), char(10))             # Mac to Unix
        
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

    # Enhanced Classic to Modern conversion with proper function/class end detection
    func convertClassicToModern cCode
        addLog("Converting from Classic to Modern style")
        
        # First pass: convert basic statements
        cResult = cCode
        
        # Handle I/O statements first (more complex)
        cResult = convertIOToModernStyle(cResult)
        
        # Simple keyword replacements
        cResult = substr(cResult, "but ", "elseif ")
        cResult = substr(cResult, "on ", "case ")
        cResult = substr(cResult, "other", "default")
        
        # Now handle the complex part: adding braces and detecting function/class ends
        cResult = addBracesAndDetectEnds(cResult)
        
        return cResult

    func addBracesAndDetectEnds cCode
        # Enhanced version that properly detects function and class boundaries
        aLines = str2list(cCode)
        aResult = []
        aStructureStack = []  # Stack to track nested structures
        nCurrentIndent = 0
        
        for i = 1 to len(aLines) {
            cLine = aLines[i]
            cTrimmed = trim(cLine)
            cIndent = left(cLine, len(cLine) - len(cTrimmed))
            nIndentLevel = len(cIndent)
            
            # Handle control structures that need opening braces
            if (left(cTrimmed, 3) = "if " or 
                left(cTrimmed, 7) = "elseif " or 
                left(cTrimmed, 6) = "while " or 
                left(cTrimmed, 4) = "for " or 
                left(cTrimmed, 7) = "switch " or 
                left(cTrimmed, 5) = "func " or 
                left(cTrimmed, 6) = "class ") and not (right(cTrimmed, 1) = "{") {
                
                # Add opening brace
                cTrimmed += " {"
                
                # Push structure onto stack
                cStructureType = ""
                if left(cTrimmed, 5) = "func " {
                    cStructureType = "func"
                elseif left(cTrimmed, 6) = "class "
                    cStructureType = "class"
                elseif left(cTrimmed, 3) = "if "
                    cStructureType = "if"
                elseif left(cTrimmed, 7) = "elseif "
                    cStructureType = "if"
                elseif left(cTrimmed, 6) = "while "
                    cStructureType = "while"
                elseif left(cTrimmed, 4) = "for "
                    cStructureType = "for"
                elseif left(cTrimmed, 7) = "switch "
                    cStructureType = "switch"
                }
                
                oStructure = [
                    :type = cStructureType,
                    :indent = nIndentLevel,
                    :line = i
                ]
                add(aStructureStack, oStructure)
            }
            
            # Handle classic endings (ok, next, off)
            if cTrimmed = "ok" or cTrimmed = "next" or cTrimmed = "off" {
                cTrimmed = "}"
                
                # Pop from stack if not empty
                if len(aStructureStack) > 0 {
                    del(aStructureStack, len(aStructureStack))
                }
            }
            
            add(aResult, cIndent + cTrimmed)
        }
        
        # Add missing closing braces for functions and classes
        # Check if we have unclosed structures at the end
        aFinalResult = aResult
        
        # Add closing braces for any remaining structures in stack
        while len(aStructureStack) > 0 {
            oStructure = aStructureStack[len(aStructureStack)]
            
            # Create appropriate indentation for closing brace
            cCloseIndent = ""
            for j = 1 to oStructure[:indent] {
                cCloseIndent += " "
            }
            
            add(aFinalResult, cCloseIndent + "}")
            del(aStructureStack, len(aStructureStack))
        }
        
        return list2str(aFinalResult)

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

    func addSimpleBraces cCode
        # Add braces after control structures in a simple way
        aLines = str2list(cCode)
        aResult = []
        
        for cLine in aLines {
            cTrimmed = trim(cLine)
            cIndent = left(cLine, len(cLine) - len(cTrimmed))
            
            # Add braces after control structures
            if (left(cTrimmed, 3) = "if " or 
                left(cTrimmed, 6) = "while " or 
                left(cTrimmed, 4) = "for " or 
                left(cTrimmed, 7) = "switch " or 
                left(cTrimmed, 5) = "func " or 
                left(cTrimmed, 6) = "class ") {
                if right(cTrimmed, 1) != "{" {
                    cTrimmed += " {"
                }
            }
            
            add(aResult, cIndent + cTrimmed)
        }
        
        return list2str(aResult)

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