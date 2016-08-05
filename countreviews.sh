#!/bin/bash

rm orderedNameAndVotes.txt
rm nameAndVotes.txt

for f in $1/*.dat;
	do 
	 PS="$(basename "$f" | cut -d. -f1)"
	 var2="$(grep -c 'Author' "$f")"
	 echo $PS $var2
done | sort -rn -k2
