# Test file for edge cases and complex scenarios

# Mixed string literals with keywords
see "This string contains 'see' and 'ok' keywords" + nl
cMessage = "if you see this, the parser works ok"
see cMessage + nl

# Nested quotes
see 'He said "Hello" to me' + nl
see "She replied 'Hi there!'" + nl

# Comments with keywords
# This comment has see and ok keywords
see "Real code here" + nl  # Comment with ok keyword

# Complex expressions
if (nAge > 18) and (cName != "") and (len(cName) > 2)
    see "Complex condition passed" + nl
ok

# Multi-line strings and expressions
cLongMessage = "This is a very long message that " +
               "spans multiple lines and contains " +
               "various keywords like see, ok, and but"
see cLongMessage + nl

# Deeply nested structures
for i = 1 to 3
    see "Level 1: " + i + nl
    for j = 1 to 2
        see "  Level 2: " + j + nl
        if i = j
            see "    Match found!" + nl
            for k = 1 to 1
                see "      Level 3: " + k + nl
                if k = 1
                    see "        Deep nesting works!" + nl
                ok
            next
        ok
    next
next

# Switch with complex expressions
nValue = 5 + 3
switch nValue
on 8
    see "Calculated value is 8" + nl
on 10
    see "Value is 10" + nl
other
    see "Unknown calculated value" + nl
off



# Array and object operations
aData = ["item1", "item2", "item3"]
nCount = processData(aData, "PREFIX_", true)
see "Processed " + nCount + " items" + nl

# Object creation and method calls
oBase = new BaseClass()
oDerived = new DerivedClass()

see "Base type: " + oBase.getType() + nl
see "Derived type: " + oDerived.getType() + nl

oBase.process()
oDerived.process()

# Error-prone constructs that should be handled correctly
cEmpty = ""
if cEmpty = ""
    see "Empty string handling works" + nl
ok

nZero = 0
if nZero = 0
    see "Zero value handling works" + nl
ok

# Unicode and special characters (if supported)
cSpecial = "Special chars: àáâãäåæçèéêë"
see cSpecial + nl

# Large data structures
aLargeArray = []
for i = 1 to 100
    aLargeArray + ("Item_" + i)
next

see "Large array created with " + len(aLargeArray) + " items" + nl

# Complex boolean expressions
lCondition1 = true
lCondition2 = false
lCondition3 = true

if (lCondition1 and lCondition3) or (not lCondition2)
    see "Complex boolean logic works" + nl
ok

see "=== Edge Cases Test Complete ===" + nl

# Function with complex parameters
func processData aItems, cPrefix, lVerbose
    if lVerbose
        see "Processing " + len(aItems) + " items with prefix: " + cPrefix + nl
    ok
    
    for i = 1 to len(aItems)
        if lVerbose
            see "  Item " + i + ": " + cPrefix + aItems[i] + nl
        ok
    next
    
    return len(aItems)

# Class with inheritance-like behavior
class BaseClass
    cType = "base"
    
    func getType
        return cType
    ok
    
    func process
        see "Base processing" + nl
    ok


class DerivedClass from BaseClass
    cType = "derived"
    
    func process
        see "Derived processing" + nl
        # Call parent method (simulated)
        see "Base processing" + nl
    ok
