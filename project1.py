# CLI Quiz Game Application
# Build a Command-Line Based Quiz Application
# Goal:
# Build an interactive quiz app that runs in the terminal and scores users based on correct answers.
# Instructions:
# Create a list of questions. Each question should have:
# The question text
# Multiple choices (A, B, C, D)
# The correct answer
# Display each question one by one using input() to collect answers.
# Use if statements to compare user answers to correct ones and assign scores.
# Use loops to iterate through the questions.
# At the end, display the total score and provide feedback.
# Features to implement:
# Use of random.shuffle() to mix question order.
# Keep track of score and give feedback: (“Excellent”, “Good”, “Try Again” based on score).
# Use try/except to handle invalid input.
# Optional extensions:
# Load questions from a .json or .csv file.
# Add timer for each question using time module.
# Allow user to choose category (e.g., math, general knowledge, history).




import random

questions = [
    { 
        "Question": "Which country won the 2022 world cup ? ,",
        "choices": ["A. Spain", "B. Brazil", "C. Argentina", "D. France"],
        "Answer": "C"

    },
    {
        "Question": "Which Programming language is commonly used with Arduino in Mechatronics?",
        "choices": ["A. Java", "B. C/C++", "C. Swift", "D. PHP"],
        "Answer": "B"

        
    },
    {
        "Question": "Which language is used for data science?",
        "choices": ["A. HTML", "B. Python", "C. CSS", "D. SQL"],
        "Answer": "B"

    },
    {
         "Question": "Which sensor is commonly used to measure distance in robotics?",
         "choices": ["A. Temperature sensor", "B. Ultrasonic sensor", "C. Pressure sensor", "D. Light sensor"],
         "Answer": "B"
    },
    {
        "Question": "Which programming platform is commonly used for building simple robotics projects?",
        "choices": ["A. Arduino", "B. Photoshop", "C. AutoCAD", "D. Excel"],
        "Answer": "A"
    },

]

random.shuffle(questions)
score = 0
for question in questions:
    print("\n" + question["Question"])

    for choice in question["choices"]:
        print(choice)

    user_answer = input("Enter A, B, C or D: ").upper()
    if user_answer == question["Answer"]:
        print("Correct!")
        score += 1
    else:
        print("Wrong!")
     
print(f"\nYour final score is: {score}")
