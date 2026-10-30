#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUMBER=$(( 1 + $RANDOM % 1000 ))

echo "Enter your username:"
read USERNAME
USER_ID=$( $PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

if [[ -n $USER_ID ]]
then 
GAMES_PLAYED=$( $PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
BEST_GAME=$( $PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

else
echo "Welcome, $USERNAME! It looks like this is your first time here."
INSERT_USER=$( $PSQL "INSERT INTO users(username) VALUES('$USERNAME')")

fi

NUMBER_OF_GUESSES=0


echo "Guess the secret number between 1 and 1000:"
read GUESS
((NUMBER_OF_GUESSES++))
 
while [[ $GUESS -ne $SECRET_NUMBER ]]
do
if ! [[ $GUESS =~ ^[0-9]+$ ]]
then
echo "That is not an integer, guess again:"
read GUESS
echo "$SECRET_NUMBER"
else 
((NUMBER_OF_GUESSES++))

if [[ $GUESS -gt $SECRET_NUMBER ]]
then 
echo "It's lower than that, guess again:"
else
echo "It's higher than that, guess again:"
fi
read GUESS
fi
done

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

UPDATE_USERS_GAMES=$( $PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$USERNAME'")
UPDATE_USERS_BEST_GAMES=$( $PSQL "UPDATE users SET best_game = LEAST(COALESCE(best_game, $NUMBER_OF_GUESSES), $NUMBER_OF_GUESSES) WHERE username = '$USERNAME'")
