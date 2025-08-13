load "src/core.ring"

try {
    ? "Testing conversion..."
    
    cCode = 'see "Hello World!"'
    ? "Original code: " + cCode
    
    oDetector = new LanguageStyleDetector
    cStyle = oDetector.detectStyle(cCode)
    ? "Detected style: " + cStyle
    
    ? "Creating converter..."
    oConverter = new LanguageStyleConverter()
    ? "Converter created"

    ? "Converting..."
    cConverted = oConverter.convertToStyle(cCode, "natural")
    ? "Converted code: " + cConverted
    
catch
    ? "Error: " + cCatchError
}
