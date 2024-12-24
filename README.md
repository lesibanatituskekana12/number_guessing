# Number Guessing Game

A simple number guessing game where you try to guess a number between 1 and 1000. The game tracks your best performance and shows the number of attempts it took to guess the correct number.

## How to Play

1. Run the script `number_guess.sh`.
2. Enter your username.
3. Guess the secret number, and the game will give you feedback if the guess is too high or too low.
4. After guessing the number, the script will tell you how many attempts it took.

## Features
- Tracks the number of games played.
- Tracks your best score (minimum number of guesses).
- Option to play again after each round.
- Handles invalid guesses with clear error messages.

## Requirements
- Bash
- PostgreSQL (for saving game data)
