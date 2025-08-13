# Test file for Natural Ring style
# This file demonstrates all Natural style features

# I/O Operations
put "=== Natural Style Test ===" + nl
put "Enter your name: "
get cUserName
put "Hello " + cUserName + "!" + nl

# Variables and basic operations
nAge = 25
cMessage = "Welcome to Ring"
lIsActive = true

# Conditional statements with 'elseif'
if nAge >= 18
    put "You are an adult" + nl
elseif nAge >= 13
    put "You are a teenager" + nl
else
    put "You are a child" + nl
end

# Loops with 'end'
put "Counting from 1 to 5:" + nl
for i = 1 to 5
    put "Number: " + i + nl
end

# While loop
nCounter = 3
while nCounter > 0
    put "Countdown: " + nCounter + nl
    nCounter = nCounter - 1
end

# Switch statement with 'case'
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
end

# Array operations
aNumbers = [10, 20, 30, 40, 50]
aNames = ["Ahmed", "Fatima", "Omar"]

for cName in aNames
    put "Processing student: " + cName + nl
end

# Nested structures
for i = 1 to 3
    put "Outer loop: " + i + nl
    for j = 1 to 2
        put "  Inner loop: " + j + nl
        if i = j
            put "    Values match!" + nl
        end
    end
end

# Try-catch example
try
    nResult = 10 / 2
    put "Division result: " + nResult + nl
catch
    put "Error occurred: " + cCatchError + nl
end

# Function calls
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
end

put "=== Natural Style Test Complete ===" + nl

# Function definition with 'def'
def greetUser cName
    if cName != ""
        put "Hello " + cName + "!" + nl
    else
        put "Hello stranger!" + nl
    end
end

def calculateSum nA, nB
    nResult = nA + nB
    return nResult
end

# Class definition
class Student
    cName = ""
    nGrade = 0
    
    def init cStudentName, nStudentGrade
        cName = cStudentName
        nGrade = nStudentGrade
    end
    
    def displayInfo
        put "Student: " + cName + nl
        put "Grade: " + nGrade + nl
    end
    
    def isPassingGrade
        if nGrade >= 60
            return true
        else
            return false
        end
    end
end
