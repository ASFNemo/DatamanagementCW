#!/bin/bash

H1=$1
H2=$2


# creating the file path
HOTEL1="reviews_folder/"$1".dat"
HOTEL2="reviews_folder/"$2".dat"

#counting the amount of reviews in each folder 
H1Aut=$(grep -c '<Author>' $HOTEL1)
H2Aut=$(grep -c '<Author>' $HOTEL2)


# here we are putting all the ratings in a seperate file 
grep '<Overall>' $HOTEL1 | sed s/\<Overall\>//g >>hotel1ratings.txt
grep '<Overall>' $HOTEL2 | sed s/\<Overall\>//g >>hotel2ratings.txt 

#Finding mean of the file
H1Av=$(awk '{sum+=$1} END {print sum/"'$H1Aut'"}' hotel1ratings.txt)
H2Av=$(awk '{sum+=$1} END {print sum/"'$H2Aut'"}' hotel2ratings.txt)


#in this section we will be finding the variance

#this next awk statement should find the top half of the variance. we will be taking the rating - the mean avarage and squaring it. we will then add all these together to give us the top part of the equation.
H1VarTop=$(awk '{sum+=(($1-"'$H1Av'")^2)} END {print sum}' hotel1ratings.txt)
H2VarTop=$(awk '{sum+=(($1-"'$H2Av'")^2)} END {print sum}' hotel2ratings.txt)

#now to find the variance we take the top that we worked out above and devide it by the amount of reviews there are.
H1Var=$(echo "scale=10; $H1VarTop/($H1Aut-1)" | bc)
H2Var=$(echo "scale=10; $H2VarTop/($H2Aut-1)" | bc)

#We will now square root the variance to find the standard deviation
H1SD=$(echo "scale=4;sqrt($H1Var)" | bc)
H2SD=$(echo "scale=4;sqrt($H2Var)" | bc)

# In the next section we will be working out Sx1x2
Sx1V=$(echo "scale=4;(($H1Aut-1)*$H1Var)" | bc)
Sx2V=$(echo "scale=4; ($H2Aut-1)*$H2Var" | bc)
Sx1x2Top=$(echo "scale=4; ($Sx1V+$Sx2V)" | bc)
Sx1x2Bottom=$(echo "scale=4; $H1Aut+$H2Aut-2" | bc)
Sx1x2sqr=$(echo "scale=4; $Sx1x2Top/$Sx1x2Bottom" | bc)
Sx1x2=$(echo "scals=4;sqrt($Sx1x2sqr)" | bc)


#Here we are working out the t-statistic using  Sx1x2 we worked out above
TTop=$(echo "scale=4; $H1Av-$H2Av" | bc)
TBSQR=$(echo "scale=4; (1/$H1Aut)+(1/$H2Aut)" | bc)
TBSQRT=$(echo "scale=4;sqrt($TBSQR)" | bc)
TBottom=$(echo "scale=4; $Sx1x2*$TBSQRT" | bc)
TStat=$(echo "scale=2; $TTop/$TBottom" | bc)

CriticalVal=1.96


echo "t: " $TStat
echo "Mean " $H1": " $H1Av " SD: " $H1SD
echo "Mean " $H2": " $H2Av " SD: " $H2SD
echo "($TStat>$CriticalVal) || ($TStat < -$CriticalVal)" | bc

rm hotel1ratings.txt 
rm hotel2ratings.txt
