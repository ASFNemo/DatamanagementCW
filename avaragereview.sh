#!/bin/bash

for file in $1/*.dat;
	do 
		#finds and counts everytime the word Author is mentioned in the file
  		n=$(grep -c Author $file)
		
		#takes the file name and 'translates' it into the hotel name. (the file name with out the .dat)
		basename $file .dat | tr '\n' '\t'
		
		# finds every instance of <overall> in the fille. it then takes the line and cuts of the <overall> leaving just the number.
		# it then takes all these numbers, adds them together and divides it all by the amount of reviews that were given
		grep '<Overall>' $file |sed s/\<Overall\>// | awk '{sum+=$1} END {print sum/"'$n'"}'

# This finishes the loop and
done | sort -r -k2 | awk '{printf $1; printf(" %.2f", $2); print "";}' 



