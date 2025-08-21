# Test file for Classic Ring style
# This file demonstrates all Classic style features

# I/O Operations
put "=== Classic Style Test ===" + nl
put "Enter your name: "
get cUserName
put "Hello " + cUserName + "!" + nl

# Variables and basic operations
nAge = 25
cMessage = "Welcome to Ring"
lIsActive = true

# Conditional statements with 'but'
if nAge >= 18
    put "You are an adult" + nl
elseif nAge >= 13
    put "You are a teenager" + nl
else
    put "You are a child" + nl
ok

# Loops with 'next'
put "Counting from 1 to 5:" + nl
for i = 1 to 5
    put "Number: " + i + nl
next

# While loop
nCounter = 3
while nCounter > 0
    put "Countdown: " + nCounter + nl
    nCounter = nCounter - 1
end

# Switch statement with 'on' and 'off'
nChoice = 2
switch nChoice
case 1
    put "First choice" + nl
case 2
    put "Second choice" + nl
case 3
    put "Third choice" + nl
other
    put "Unknown choice" + nl
off

# Array operations
aNumbers = [10, 20, 30, 40, 50]
aNames = ["Ahmed", "Fatima", "Omar"]

for cName in aNames
    put "Processing student: " + cName + nl
next

# Nested structures
for i = 1 to 3
    put "Outer loop: " + i + nl
    for j = 1 to 2
        put "  Inner loop: " + j + nl
        if i = j
            put "    Values match!" + nl
        end
    end
next

# Functicase calls
greetUser(cUserName)
nSum = calculateSum(15, 25)
put "Sum result: " + nSum + nl

# Object usage
oStudent = new Student("Ali Hassan", 85)
oStudent.displayInfo()

if oStudent.isPassingGrade()
    put "Student is passing!" + nl
else
    put "Student needs improvement" + nl
ok

put "=== Classic Style Test Complete ===" + nl

# Functicase definition
func greetUser cName
    if cName != ""
        put "Hello " + cName + "!" + nl
    else
        put "Hello stranger!" + nl
    end


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
        put "Student: " + cName + nl
        put "Grade: " + nGrade + nl


    func isPassingGrade
        if nGrade >= 60
            return true
        else
            return false
        end