/*
	Title :	RingFmt Comprehensive Test Suite
	Date  : 2025.08.12
	Author: Azzeddine
	Description: Automated testing for all RingFmt features
*/

load "../src/core.ring"

# Test configuration
aTestFiles = [
	"test_classic_style.ring",
	"test_natural_style.ring", 
	"test_modern_style.ring"
]

aTargetStyles = ["classic", "natural", "modern"]

func main
	showTitle()
	? "Running comprehensive RingFmt test suite..."
	line75()
	
	nTotalTests = 0
	nPassedTests = 0
	nFailedTests = 0
	
	# Test 1: Style Detection
	? "=== Testing Style Detection ==="
	for cTestFile in aTestFiles {
		nTotalTests++
		if testStyleDetection(cTestFile) {
			nPassedTests++
		else
			nFailedTests++
		}
	}
	
	# Test 2: Style Conversion
	? nl + "=== Testing Style Conversion ==="
	for cSourceFile in aTestFiles {
		for cTargetStyle in aTargetStyles {
			nTotalTests++
			if testStyleConversion(cSourceFile, cTargetStyle) {
				nPassedTests++
			else
				nFailedTests++
			}
		}
	}
	
	# Test 3: Validation Features
	? nl + "=== Testing Validation Features ==="
	for cTestFile in aTestFiles {
		nTotalTests++
		if testValidation(cTestFile) {
			nPassedTests++
		else
			nFailedTests++
		}
	}
	
	# Test 4: Format-only Features
	? nl + "=== Testing Format-only Features ==="
	for cTestFile in aTestFiles {
		nTotalTests++
		if testFormatOnly(cTestFile) {
			nPassedTests++
		else
			nFailedTests++
		}
	}
	
	# Test 5: Error Handling
	? nl + "=== Testing Error Handling ==="
	nTotalTests++
	if testErrorHandling() {
		nPassedTests++
	else
		nFailedTests++
	}
	
	# Show results
	line75()
	? "=== Test Results ==="
	? "Total tests: " + nTotalTests
	? "Passed: " + nPassedTests
	? "Failed: " + nFailedTests
	? "Success rate: " + ((nPassedTests * 100) / nTotalTests) + "%"
	
	if nFailedTests = 0 {
		? "🎉 All tests passed!"
	else
		? "❌ Some tests failed. Please check the output above."
	}
	line75()

func testStyleDetection cTestFile
	try {
		? "Testing detection for: " + cTestFile
		
		# Read test file
		cCode = readFileWithEncoding(cTestFile)
		if cCode = "" {
			? "  ❌ Could not read test file"
			return false
		}
		
		# Detect style
		oDetector = new LanguageStyleDetector
		cDetectedStyle = oDetector.detectStyle(cCode)
		
		# Determine expected style from filename
		cExpectedStyle = ""
		if substr(cTestFile, "classic") > 0 { cExpectedStyle = "classic" }
		if substr(cTestFile, "natural") > 0 { cExpectedStyle = "natural" }
		if substr(cTestFile, "modern") > 0 { cExpectedStyle = "modern" }
		
		if cDetectedStyle = cExpectedStyle {
			? "  ✅ Correctly detected: " + cDetectedStyle
			return true
		else
			? "  ❌ Expected: " + cExpectedStyle + ", Got: " + cDetectedStyle
			return false
		}
		
	catch
		? "  ❌ Error in detection test: " + cCatchError
		return false
	}

func testStyleConversion cSourceFile, cTargetStyle
	try {
		? "Converting " + cSourceFile + " to " + cTargetStyle
		
		# Read source file
		cCode = readFileWithEncoding(cSourceFile)
		if cCode = "" {
			? "  ❌ Could not read source file"
			return false
		}
		
		# Convert
		oConverter = new LanguageStyleConverter()
		cConverted = oConverter.convertToStyle(cCode, cTargetStyle)
		
		# Validate result
		if not validateRingSyntax(cConverted) {
			? "  ❌ Conversion resulted in invalid syntax"
			return false
		}
		
		# Check if target style is achieved
		oDetector = new LanguageStyleDetector
		cResultStyle = oDetector.detectStyle(cConverted)
		
		if cResultStyle = cTargetStyle {
			? "  ✅ Successfully converted to " + cTargetStyle
			return true
		else
			? "  ❌ Target: " + cTargetStyle + ", Result: " + cResultStyle
			return false
		}
		
	catch
		? "  ❌ Error in conversion test: " + cCatchError
		return false
	}

func testValidation cTestFile
	try {
		? "Validating: " + cTestFile
		
		cCode = readFileWithEncoding(cTestFile)
		if cCode = "" {
			? "  ❌ Could not read test file"
			return false
		}
		
		if validateRingSyntax(cCode) {
			? "  ✅ Syntax validation passed"
			return true
		else
			? "  ❌ Syntax validation failed"
			return false
		}
		
	catch
		? "  ❌ Error in validation test: " + cCatchError
		return false
	}

func testFormatOnly cTestFile
	try {
		? "Testing format-only for: " + cTestFile
		
		cCode = readFileWithEncoding(cTestFile)
		if cCode = "" {
			? "  ❌ Could not read test file"
			return false
		}
		
		# Apply formatting
		cFormatted = normalizeIndentation(cCode, 4)
		cFormatted = removeExtraBlankLines(cFormatted)
		
		if validateRingSyntax(cFormatted) {
			? "  ✅ Format-only test passed"
			return true
		else
			? "  ❌ Format-only resulted in invalid syntax"
			return false
		}
		
	catch
		? "  ❌ Error in format-only test: " + cCatchError
		return false
	}

func testErrorHandling
	try {
		? "Testing error handling..."
		
		# Test with non-existent file
		if fexists("nonexistent.ring") {
			? "  ❌ Non-existent file test failed"
			return false
		}
		
		# Test with invalid syntax - unmatched quotes
		cInvalidCode = 'see "This string has no closing quote' + nl + 'see "Another line"'
		if validateRingSyntax(cInvalidCode) {
			? "  ❌ Invalid syntax was not detected"
			return false
		}
		
		? "  ✅ Error handling tests passed"
		return true
		
	catch
		? "  ❌ Error in error handling test: " + cCatchError
		return false
	}


