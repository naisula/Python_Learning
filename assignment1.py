##QUESTION 1: program that asks the user to inputs two numbers and an operator and performs
num1=int(input("First number:")) #promts the user to enter a number
num2=int(input("Second number:"))
operator=(input("operator:"))# promts the user to enter a valid operator

match operator: # checks the value of the variable operator, what operator the user has inserted
    case "+":# if + it adds the two numbers
        print(num1+ num2)
    case "-":#subtracts the two numbers
        print(num1-num2)
    case "*":#multiplies the two numbers
        print(num1*num2)
    case "/":#division
        print(num1 / num2)
    case _ :
        print("Invalid operator")#returns an error if the user inputs and invalid operator

##QUESTION 2:program that generates and prints a random number between 1 and 100 using random library
import random#this tells python to use random in the built in library
number = random.randint(1,100)# tells the computer to generatea random integer between and including 1 and 100
print("Random number is:", number)
##QUESTION 3:write a program that calculates and prints the sqrt of a given number using the math.sqrt function
import math
square_number=float(input("number:"))
sqrt=math.sqrt(square_number)
print(sqrt)

