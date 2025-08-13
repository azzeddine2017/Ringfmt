# Test file for Classic Ring style
# This file demonstrates all Classic style features

# I/O Operations
see "=== Classic Style Test ===" + nl
see "Enter your name: "
give cUserName
see "Hello " + cUserName + "!" + nl

# Variables and basic operations
nAge = 25
cMessage = "Welcome to Ring"
lIsActive = true

# Conditional statements with 'but'
if nAge >= 18
    see "You are an adult" + nl
but nAge >= 13
    see "You are a teenager" + nl
else
    see "You are a child" + nl
ok

# Loops with 'next'
see "Counting from 1 to 5:" + nl
for i = 1 to 5
    see "Number: " + i + nl
next

# While loop
nCounter = 3
while nCounter > 0
    see "Countdown: " + nCounter + nl
    nCounter = nCounter - 1
end

# Switch statement with 'on' and 'off'
nChoice = 2
switch nChoice
on 1
    see "First choice" + nl
on 2
    see "Second choice" + nl
on 3
    see "Third choice" + nl
other
    see "Unknown choice" + nl
off

# Array operations
aNumbers = [10, 20, 30, 40, 50]
aNames = ["Ahmed", "Fatima", "Omar"]

for cName in aNames
    see "Processing student: " + cName + nl
next

# Nested structures
for i = 1 to 3
    see "Outer loop: " + i + nl
    for j = 1 to 2
        see "  Inner loop: " + j + nl
        if i = j
            see "    Values match!" + nl
        ok
    next
next

# Function calls
greetUser(cUserName)
nSum = calculateSum(15, 25)
see "Sum result: " + nSum + nl

# Object usage
oStudent = new Student("Ali Hassan", 85)
oStudent.displayInfo()

if oStudent.isPassingGrade()
    see "Student is passing!" + nl
else
    see "Student needs improvement" + nl
ok

see "=== Classic Style Test Complete ===" + nl

# Function definition
func greetUser cName
    if cName != ""
        see "Hello " + cName + "!" + nl
    else
        see "Hello stranger!" + nl
    ok


func calculateSum nA, nB
    nResult = nA + nB
    return nResult

# Class definition
class Student
    cName = ""
    nGrade = 0
    
    func init cStudentName, nStudentGrade
        cName = cStudentName
        nGrade = nStudentGrade
    
    
    func displayInfo
        see "Student: " + cName + nl
        see "Grade: " + nGrade + nl
    
    
    func isPassingGrade
        if nGrade >= 60
            return true
        else
            return false
        ok
    

