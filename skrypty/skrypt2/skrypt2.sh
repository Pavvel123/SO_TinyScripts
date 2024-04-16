#!/bin/bash
FILENAME="abc.txt"
FOLDER="."
GT="0"
LT="10"
CONTENT="aa"

INPUT=0

while [ $INPUT -ne 7 ]
do
	clear
	echo "The File Finder"
	echo "1. filename		${FILENAME}"
	echo "2. folder		${FOLDER}"
	echo "3. greater than		${GT}"
	echo "4. less than		${LT}"
	echo "5. content		${CONTENT}"
	echo "6. search"
	echo "7. quit"

	read INPUT

	case $INPUT in
		1)
		echo "write filename:"
		read FILENAME
		;;
		2)
		echo "write folder name:"
		read FOLDER
		;;
		3)
		echo "size greater than:"
		read GT
		;;
		4)
		echo "size less than:"
		read LT
		;;
		5)
		echo "content of the file:"
		read CONTENT
		;;
		6)
		if [ -z "$FOLDER" ] || [ -z "$FILENAME" ] || [ -z "$GT" ] || [ -z "$LT" ] || [ -z "$CONTENT" ]
		then
 		   echo "Ooops... Some variables are empty."
		else
			RESULT=$(find "$FOLDER" -type f -name "$FILENAME" -size +"$GT" -size -"$LT" -exec grep -q "$CONTENT" {} \; -print)
			if [ -z "$RESULT" ]
			then
			    echo "File doesn't exist."
			else
				echo "File exists!"
			fi
		fi
		read
		;;
		7)
		echo "Bye bye!"
		;;
	esac
done