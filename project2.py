'''

Number Guessing Game
Build a Guess the Number (with Difficulty Levels) Game
Goal:
Create a guessing game where the computer generates a random number and the user tries to guess it.
Instructions:
Use random.randint() to generate a number between 1 and 100.
Ask the user to input guesses and give feedback: “Too High”, “Too Low”.
Limit the number of guesses to 5–10 depending on the level.
Features to implement:
Allow user to choose difficulty: Easy (10 tries), Medium (7), Hard (5).
Count attempts and print remaining guesses.
End game on correct guess or when attempts run out.
Optional extensions:
Save high scores (username + score) to a .txt file.
Give a hint after 3 wrong tries (e.g., divisible by...).
Build a simple leaderboard.

'''

import random

number = random.randint(1,100)

# define a function to set the difficulty level 
def get_attempts():
    difficulty = input("Choose difficulty(Easy,Medium,Hard):").lower()

    if difficulty == "easy":
        return 10 # returns the number of attempts remaining
    elif difficulty == "medium":
        return 7
    elif difficulty == "hard":
        return 5
    else:
        print("Invalid choice. ")

attempts = get_attempts()
   
while attempts > 0:
    print(f"You have {attempts } attempts left")
    #asks the user to guess a number between 1 and 100

    guess = int(input('Guess a number between 1 and 100: '))
    if guess == number :
       print('You guessed the right number') 
       break # breaks the loops when the user guesses the right number
    elif guess < number:
       print('Too Low') 
    else:
        print('Too High') 
    attempts -= 1 # loop runs until attempts are done

    if attempts == 3: # code for hint
        if number % 2 == 0:
            print("The number is even")
        else:
            print("The number is odd")
    
if attempts == 0:
    print(f"Game over! The number was {number}")
        

