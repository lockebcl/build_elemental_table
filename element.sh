#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    ELEMENT $1
  fi
}

ELEMENT () {
  ELEMENT=$1

  if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT' OR name='$ELEMENT'")| sed 's/ //g')
  else
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT") | sed 's/ //g')
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    TYPE_ID=$(echo $($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    ATOMIC_MASS=$(echo $($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    MELTING_POINT_CELSIUS=$(echo $($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    BOILING_POINT_CELSIUS=$(echo $($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    TYPE=$(echo $($PSQL "SELECT type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi

}

MAIN $1