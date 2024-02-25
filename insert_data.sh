#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
  #get winner id
  WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  #if not entered
  if [[ -z $WINNER_TEAM_ID ]]
  then
  #insert winner
    INSERT_WINNER_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    if [[ $INSERT_WINNER_RESULT = 'INSERT 0 1' ]]
    then
    echo inserted $WINNER
    fi
    WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  fi
  #get opponent id
  OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  #if not found
  if [[ -z $OPPONENT_TEAM_ID ]]
  then
    #add opponent team
    INSERT_OPPONENT_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    if [[ $INSERT_OPPONENT_RESULT = 'INSERT 0 1' ]]
    then
    echo inserted $OPPONENT
    fi
    OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  fi
  INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_TEAM_ID, $OPPONENT_TEAM_ID)")"
  if [[ INSERT_GAME_RESULT = 'INSERT 0 1' ]]
  then
  echo inserted '$ROUND' game from $YEAR
  fi
  fi
done