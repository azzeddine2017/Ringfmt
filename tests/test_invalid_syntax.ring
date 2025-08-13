# Test file with intentional syntax errors
# This file is used to test error handling capabilities

# Missing ok statement
if x > 0
    see "This if statement is missing ok"

# Missing next statement  
for i = 1 to 5
    see "This loop is missing next"

# Missing off statement
switch nValue
on 1
    see "Case 1"
on 2
    see "Case 2"

# Unmatched quotes
see "This string is missing closing quote

# Unmatched parentheses
if (x > 0
    see "Missing closing parenthesis"
ok

# Invalid function definition
func invalidFunction(
    see "Invalid parameter syntax"


# Missing function end
func anotherFunction
    see "This function has no end"

# Invalid class definition
class InvalidClass
    cName = "test"
    # Missing 

# Nested structure errors
for i = 1 to 3
    if i > 1
        see "Nested without proper closing"
    # Missing ok
# Missing next
