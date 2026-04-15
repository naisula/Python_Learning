#EXERCISE 1:a program that uses input to promt their name and then welcomes them
name=input("Enter your name:") #prompts the user for their name
print("Hello ",name) #prints out the name and greeting

#EXERCISE 2:Write a program to prompt the user for hours and rate per hour to compute gross pay.
"""
 prompts the user for working hours and rate per hour
 and stores the output as a float
"""
working_hours=float(input("Hours worked:"))
rate_per_hour=float(input("Rate per hour:"))
gross= working_hours *rate_per_hour 
print(gross)

#EXERCISE 3:Assignment statements
width=17   #stores the variable as an integer
height=12.0  #stores the variable as a float
print(width//2,type(width//2))  #floor division of 2 then prints the value and type
print(width/2.0,type(width/2.0))  #float division of 2.0 then prints the value and type
print(height/3,type(height/3)) #divides height by 3 and displays the type after division
print(1+2*5,type(1+2*5)) #evaluates the expression then displays the type

#EXERCISE 4:prompts the user for a celcius temperature, convert to faranheit and print the converted temperature
Celcius_temp=float(input("Enter temperature in degree celcius "))
Fahrenheit= Celcius_temp*2 +30
print(Fahrenheit)




