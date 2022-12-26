#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]] 
then
  echo Please provide an element as an argument.
else
  SUM=0
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements")
  ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements")
  ATOMIC_NAME=$($PSQL "SELECT name FROM elements")

  for n in $ATOMIC_NUMBER
  do 
    if [[ $1 = $n ]]
    then
      ATOMIC_NUMBER=$n
      ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $n")
      ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $n")
      TYPE=$($PSQL "SELECT type FROM types LEFT JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $1")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $n")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $n")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $n")
      SUM=SUM+1
    fi
  done

  for n in $ATOMIC_SYMBOL
  do 
    if [[ $1 = $n ]]
    then
      ATOMIC_SYMBOL=$n
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$n'")
      ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$n'")
      TYPE=$($PSQL "SELECT type FROM types LEFT JOIN properties ON types.type_id = properties.type_id LEFT JOIN elements ON elements.atomic_number = properties.atomic_number WHERE elements.symbol = '$1'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
      SUM=SUM+1
    fi
  done

  for n in $ATOMIC_NAME
  do 
    if [[ $1 = $n ]]
    then
      ATOMIC_NAME=$n
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$n'")
      ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$n'")
      TYPE=$($PSQL "SELECT type FROM types LEFT JOIN properties ON types.type_id = properties.type_id LEFT JOIN elements ON elements.atomic_number = properties.atomic_number WHERE elements.name = '$n'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
      SUM=SUM+1
    fi
  done

  if [[ $SUM = 0 ]]
  then
    echo I could not find that element in the database.
  else
    echo -e "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi