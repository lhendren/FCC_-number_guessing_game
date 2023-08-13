#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# Prompt the user for a username
echo "Enter your username:"
SECRET_NUMBER=$((RANDOM % 1000 + 1))
read USERNAME

RETURNING_USER=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")

if [[ -z $RETURNING_USER ]]
then

  INSERT_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."

else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN users USING(user_id) WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN users USING(user_id) WHERE username = '$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# get user_id
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")


# echo "$SECRET_NUMBER"

TRIES=1
GUESS=0

GUESSING_MACHINE(){

read GUESS


while [[  $GUESS =~ ^[0-9]+$  && $GUESS -ne $SECRET_NUMBER ]]
do

    TRIES=$(expr $TRIES + 1)

      if [[ $GUESS -gt $SECRET_NUMBER ]]
      then

        echo "It's lower than that, guess again:"
        read GUESS

      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then

        echo "It's higher than that, guess again:"
        read GUESS

      fi
      done
      if [[ ! $GUESS =~ ^[0-9]+$ ]]
        then
          echo "That is not an integer, guess again:"
          GUESSING_MACHINE
        fi

}

echo $GUESS
echo "Guess the secret number between 1 and 1000:"
GUESSING_MACHINE





  #insert data from game
  INSERTED_GAMES=$($PSQL "INSERT INTO games (user_id, guesses) VALUES ($USER_ID, $TRIES)")
  echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"

