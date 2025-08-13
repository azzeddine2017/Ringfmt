# RingFmt - Ring Code Formatter User Guide

## Overview

RingFmt is a comprehensive command-line tool for formatting Ring programming language code. It supports automatic style detection and conversion between three different Ring language styles:

- **Classic Style**: Traditional Ring syntax with `see/give`, `func...`, `if...ok`
- **Natural Style**: Modified syntax with `put/get`, `def...end`, `if...end`
- **Modern Style**: C-like syntax with `print()`, `func{}`, `if(){}`

## Installation

1. Ensure Ring programming language is installed on your system
2. Download or clone the RingFmt project
3. Navigate to the RingFmt directory

## Basic Usage

### Command Syntax
```bash
ring ringfmt.ring <input_file> [options]
```

### Style Conversion Options

#### Convert to Classic Style
```bash
ring ringfmt.ring mycode.ring -classic
```

#### Convert to Natural Style
```bash
ring ringfmt.ring mycode.ring -natural
```

#### Convert to Modern Style
```bash
ring ringfmt.ring mycode.ring -modern
```

### Analysis Options

#### Detect Current Style
```bash
ring ringfmt.ring mycode.ring -detect
```

#### Validate Syntax
```bash
ring ringfmt.ring mycode.ring -validate
```

### Formatting Options

#### Format Code (normalize indentation)
```bash
ring ringfmt.ring mycode.ring -format
```

#### Custom Indentation
```bash
ring ringfmt.ring mycode.ring -format -indent 2
```

### Output Options

#### Specify Output File
```bash
ring ringfmt.ring input.ring -modern -output formatted.ring
```

#### Force Conversion (ignore syntax errors)
```bash
ring ringfmt.ring input.ring -modern -force
```

### Debug Options

#### Show Detailed Process
```bash
ring ringfmt.ring input.ring -modern -debug
```

## Style Examples

### Classic Style
```ring
# I/O Operations
see "Hello World!" + nl
give cUserName

# Conditional Statements
if nAge >= 18
    see "Adult"
but nAge >= 13
    see "Teenager"
else
    see "Child"
ok

# Loops
for i = 1 to 10
    see "Number: " + i + nl
next

# Functions
func greetUser cName
    if cName != ""
        see "Hello " + cName + "!"
    else
        see "Hello stranger!"
    ok

```

### Natural Style
```ring
# I/O Operations
put "Hello World!" + nl
get cUserName

# Conditional Statements
if nAge >= 18
    put "Adult"
elseif nAge >= 13
    put "Teenager"
else
    put "Child"
end

# Loops
for i = 1 to 10
    put "Number: " + i + nl
next

# Functions
def greetUser cName
    if cName != ""
        put "Hello " + cName + "!"
    else
        put "Hello stranger!"
    end
end
```

### Modern Style
```ring
# I/O Operations
print("Hello World!" + nl)
cUserName = getstring()

# Conditional Statements
if nAge >= 18 {
    print("Adult")
elseif nAge >= 13 
    print("Teenager")
else 
    print("Child")
}

# Loops
for i = 1 to 10 {
    print("Number: " + i + nl)
}

# Functions
func greetUser cName {
    if cName != "" {
        print("Hello " + cName + "!")
    else 
        print("Hello stranger!")
    }
}
```

## Advanced Features

### Automatic Backup
When overwriting files, RingFmt automatically creates a backup with `.backup` extension.

### Syntax Validation
RingFmt validates Ring syntax before and after conversion to ensure code integrity.

### File Size Limits
Maximum file size: 10MB (configurable)

### Encoding Support
Supports UTF-8 encoding with BOM detection and removal.

### Error Handling
Comprehensive error handling with detailed error messages and suggestions.

## Testing

### Run All Tests
```bash
cd tests
ring run_all_tests.ring
```

### Test Individual Styles
```bash
ring ringfmt.ring tests/test_classic_style.ring -detect
ring ringfmt.ring tests/test_natural_style.ring -detect
ring ringfmt.ring tests/test_modern_style.ring -detect
```

## Troubleshooting

### Common Issues

1. **Syntax Errors**: Use `-validate` to check syntax before conversion
2. **Large Files**: Split files larger than 10MB
3. **Encoding Issues**: Ensure files are in UTF-8 encoding
4. **Permission Errors**: Check file read/write permissions

### Debug Mode
Use `-debug` flag to see detailed conversion process and identify issues.

### Force Mode
Use `-force` flag to proceed with conversion despite syntax errors (not recommended).

## Contributing

1. Fork the repository
2. Create feature branch
3. Add tests for new features
4. Ensure all tests pass
5. Submit pull request

## License

This project is open source. Please refer to the LICENSE file for details.

## Support

For issues and questions:
1. Check this user guide
2. Run tests to verify installation
3. Use debug mode to diagnose problems
4. Report issues with detailed error messages
