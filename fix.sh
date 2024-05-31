#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


RENAME_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")
echo -e "\nweight Column Renamed to atomic_mass"

RENAME_MELTING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")
echo -e "\nmelting_point Renamed to melting_point_celsius"

RENAME_BOILING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")
echo -e "\nboiling_point Renamed to boiling_point_celsius"

MAKE_MELTING_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")
MAKE_BOILING_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")
echo -e "\nBoth Melting and Boiling point no longer take Null values"


MAKE_SYMBOL_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol)")
MAKE_NAME_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(name)")
MAKE_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")
MAKE_NAME_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")
echo -e "\n Name and symbol are now unique and no longer takes NULL values"

ATOMIC_NUMBER_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)")
echo -e "\n Atomic number is now a foreign key"

CREATE_TYPES_TABLE=$($PSQL "CREATE TABLE types(type_id SERIAL PRIMARY KEY, 
	type VARCHAR(40) NOT NULL)")

ADD_TYPE_ID_PROPERTIES=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT")

ADD_TYPES_INTO_TYPES=$($PSQL "INSERT INTO types(type) SELECT DISTINCT(type) FROM properties")
ALL_TYPES=$($PSQL "SELECT * FROM types")
echo -e "\nTable Types Created see below"
echo -e "\n$ALL_TYPES"

PROPERTIES_TYPES=$($PSQL "UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type =types.type)")
PROPERTIES_ID_TEST=$($PSQL "SELECT type_id FROM properties")
echo -e "\nType ID added to properties"
echo -e "\n$PROPERTIES_ID_TEST"

TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER type_id SET NOT NULL")
TYPE_ID_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id)")
echo -e "\n Type ID is now a foreign key and not null in properties"

CAPITALIZE_SYMBOL=$($PSQL "UPDATE elements SET symbol=INITCAP(symbol)")
echo -e "\nAll records in Elements should have a capital letter beginning they symbol columm"
SYMBOLS=$($PSQL "SELECT symbol FROM elements")
echo -e "\n$SYMBOLS"

MAKE_DECIMAL=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE VARCHAR(10)")
DEL_TRAILING_ZEROS=$($PSQL "UPDATE properties SET atomic_mass=CAST(atomic_mass AS FLOAT)")
echo -e "\ntrailing zeros gone"
AT_MASS=$($PSQL "SELECT atomic_mass FROM properties")
echo -e "\n$AT_MASS"

ADD_NINE_ELEMENT=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine')")
ADD_NINE_PROP=$($PSQL "INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(9, 'nonmetal', 18.998, -220, -188.1, 3)")

ADD_TEN_ELEMENT=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(10,'Ne','Neon');")
ADD_TEN_PROP=$($PSQL "INSERT INTO properties(atomic_number,type,melting_point_celsius,boiling_point_celsius,type_id,atomic_mass) VALUES(10,'nonmetal',-248.6,-246.1,3,'20.18');")

DROP_TYPE=$($PSQL "ALTER TABLE properties DROP COLUMN type")
echo -e "\n Dropped type column from properties"

DROP_FROM_PROPS=$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
DROP_FROM_ELEMENTS=$($PSQL "DELETE FROM elements WHERE atomic_number=1000")

