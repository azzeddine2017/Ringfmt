# Test file for Modern Ring style
# This file demonstrates all Modern style features

# I/O Operations
print("=== Modern Style Test ===" + nl)
print("Enter your name: ")
cUserName = getstring()
print("Hello " + cUserName + "!" + nl)

# Variables and basic operations
nAge = 25
cMessage = "Welcome to Ring"
lIsActive = true

# Conditional statements with braces
if nAge >= 18 {
    print("You are an adult" + nl)
elseif nAge >= 13 
    print("You are a teenager" + nl)
else 
    print("You are a child" + nl)
}

# Loops with braces
print("Counting from 1 to 5:" + nl)
for i = 1 to 5 {
    print("Number: " + i + nl)
}

# While loop
nCounter = 3
while nCounter > 0 {
    print("Countdown: " + nCounter + nl)
    nCounter = nCounter - 1
}

# Switch statement with case: and default:
nChoice = 2
switch nChoice {
case 1
    print("First choice" + nl)
case 2
    print("Second choice" + nl)
case 3
    print("Third choice" + nl)
default
    print("Unknown choice" + nl)
}


# Array operations
aNumbers = [10, 20, 30, 40, 50]
aNames = ["Ahmed", "Fatima", "Omar"]

for cName in aNames {
    print("Processing student: " + cName + nl)
}

# Nested structures
for i = 1 to 3 {
    print("Outer loop: " + i + nl)
    for j = 1 to 2 {
        print("  Inner loop: " + j + nl)
        if i = j {
            print("    Values match!" + nl)
        }
    }
}

# Try-catch with braces
try {
    nResult = 10 / 2
    print("Division result: " + nResult + nl)
catch 
    print("Error occurred: " + cCatchError + nl)
}

# Control flow statements
for i = 1 to 10 {
    if i = 5 {
        continue  # Skip iteration
    }
    if i = 8 {
        break     # Exit loop
    }
    print("Value: " + i + nl)
}

# Function calls
greetUser(cUserName)
nSum = calculateSum(15, 25)
print("Sum result: " + nSum + nl)

# Object usage
oStudent = new Student("Ali Hassan", 85)
oStudent.displayInfo()

if oStudent.isPassingGrade() {
    print("Student is passing!" + nl)
else 
    print("Student needs improvement" + nl)
}

print("=== Modern Style Test Complete ===" + nl)

# Function definition with braces
func greetUser cName {
    if cName != "" {
        print("Hello " + cName + "!" + nl)
    else 
        print("Hello stranger!" + nl)
    }
}

func calculateSum nA, nB {
    nResult = nA + nB
    return nResult
}

# Class definition with braces
class Student {
    cName = ""
    nGrade = 0
    
    func init cStudentName, nStudentGrade {
        cName = cStudentName
        nGrade = nStudentGrade
    }
    
    func displayInfo {
        print("Student: " + cName + nl)
        print("Grade: " + nGrade + nl)
    }
    
    func isPassingGrade {
        if nGrade >= 60 {
            return true
        else 
            return false
        }
    }
}
