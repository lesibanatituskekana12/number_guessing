#!/bin/bash

# Define the PostgreSQL command to interact with the database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Function to display the intro and gather user information
DISPLAY() {
  echo -e "\n~~~~~ Number Guessing Game ~~~~~\n" 

  # Prompt the user for their username
  echo "Enter your username:"
  read USERNAME

  # Check if the username exists in the database
  USER_ID=$($PSQL "SELECT u_id FROM users WHERE name = '$USERNAME'")

  # If the user exists
  if [[ $USER_ID ]]; then
    # Get the number of games played by the user
    GAMES_PLAYED=$($PSQL "SELECT count(u_id) FROM games WHERE u_id = '$USER_ID'")

    # Get the best game (fewest guesses) for the user
    BEST_GUESS=$($PSQL "SELECT min(guesses) FROM games WHERE u_id = '$USER_ID'")

    # Output the user's statistics
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GUESS guesses."
  else
    # If the user is new, insert them into the database
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    INSERTED_TO_USERS=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    
    # Get the newly inserted user_id
    USER_ID=$($PSQL "SELECT u_id FROM users WHERE name = '$USERNAME'")
  fi

  # Start the game
  GAME
}

# Function to handle the game logic
GAME() {
  # Generate a random secret number between 1 and 1000
  SECRET=$((1 + RANDOM % 1000))

  # Initialize the guess counter
  TRIES=0

  # Set the guessed flag to false
  GUESSED=0

  echo -e "\nGuess the secret number between 1 and 1000:"

  # Loop until the user guesses the correct number
  while [[ $GUESSED = 0 ]]; do
    read GUESS

    # Validate if the input is an integer
    if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
      echo -e "\nThat is not an integer, guess again:"
    # Check if the guess is correct
    elif [[ $SECRET = $GUESS ]]; then
      TRIES=$((TRIES + 1))
      echo -e "\nYou guessed it in $TRIES tries. The secret number was $SECRET. Nice job!"
      
      # Insert the result into the games table
      INSERTED_TO_GAMES=$($PSQL "INSERT INTO games(u_id, guesses) VALUES($USER_ID, $TRIES)")

      # Set the guessed flag to true
      GUESSED=1
    # Check if the guess is too high
    elif [[ $SECRET -gt $GUESS ]]; then
      TRIES=$((TRIES + 1))
      echo -e "\nIt's higher than that, guess again:"
    # Check if the guess is too low
    else
      TRIES=$((TRIES + 1))
      echo -e "\nIt's lower than that, guess again:"
    fi
  done

  # Thank the user for playing after they win
  echo -e "\nThanks for playing :)\n"
}

# Call the DISPLAY function to start the game
DISPLAY
