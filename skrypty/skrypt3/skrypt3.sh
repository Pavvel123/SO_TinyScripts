#!/bin/bash
INPUT=0
MENU=(
 "1. filename"
 "2. folder"
 "3. greater than"
 "4. less than"
 "5. content"
 "search"
 "quit"
)
VALUES=(
    "abc.txt"
    "."
    "0"
    "10"
    "aa"
)

while [ $INPUT -ne 7 ]
do
    CHOICE=$(zenity --list --column="property" --column="value" --separator=" " \
        "${MENU[0]}" "${VALUES[0]}" \
        "${MENU[1]}" "${VALUES[1]}" \
        "${MENU[2]}" "${VALUES[2]}" \
        "${MENU[3]}" "${VALUES[3]}" \
        "${MENU[4]}" "${VALUES[4]}" \
        "${MENU[5]}" ""\
        "${MENU[6]}" ""\
        --height 400 --width 300 --title "The File Finder" --text "Choose one option:")
    if  [ $? -eq 1 ]
    then
        INPUT=7
    fi
    case "$CHOICE" in 
        "${MENU[0]}")
            VALUES[0]=$(zenity --entry --title "The File Finder" --text "Write filename:")
        ;;
        "${MENU[1]}")
            VALUES[1]=$(zenity --entry --title "The File Finder" --text "Write folder name:")
        ;;
        "${MENU[2]}")
            VALUES[2]=$(zenity --entry --title "The File Finder" --text "Size greater than:")
        ;;
        "${MENU[3]}")
            VALUES[3]=$(zenity --entry --title "The File Finder" --text "Size less than:")
        ;;
        "${MENU[4]}")
            VALUES[4]=$(zenity --entry --title "The File Finder" --text "content of the file:")
        ;;
        "${MENU[5]}")
            if [ -z "${VALUES[1]}" ] || [ -z "${VALUES[0]}" ] || [ -z "${VALUES[2]}" ] || [ -z "${VALUES[3]}" ] || [ -z "${VALUES[4]}" ]
            then
                zenity --error --text "Ooops... Some variables are empty."
	        else
		        result=$(find "${VALUES[1]}" -type f -name "${VALUES[0]}" -size +"${VALUES[2]}" -size -"${VALUES[3]}" -exec grep -q "${VALUES[4]}" {} \; -print)
                #zenity --progress --text "Szukanie pliku. To może chwilę potrwać..." --title "SKRYPT 3" 
		        if [ -z "$result" ]
                then
                    zenity --warning --text "File doesn't exist."
		        else
                    zenity --info --title "The File Finder" --text "File exists!"
		        fi
	        fi
        ;;
        "${MENU[6]}")
            INPUT=7
        ;;
    esac
done