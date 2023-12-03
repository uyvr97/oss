#! /bin/bash
echo "--------------------------
User Name: 도가현
Student Number: 12211600
[ MENU ]
1. Get the data of the movie identified by a specific 
'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by 
specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’
7. Get the data of movies rated by a specific 'user id' 
from 'u.data'
8. Get the average 'rating' of movies rated by users with 
'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"

while true
do 
	read -p "Enter your choice [ 1-9 ] " select
	echo
	case $select in
	1)
		read -p "Please enter the 'movie id’(1~1682) : " id
		echo
		cat $1 | awk -F\| '$1=='$id'{print $0}'
		;;
	2)	
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n) : " ans
	       	echo
		if [ $ans = "y" ]
		then	
			cat $1 | awk -F\| '$7==1{print $1, $2}' | head
		fi
		;;
	3)
		read -p "Please enter the 'movie id’(1~1682) : " id
		echo
		cat $2 | awk '$2=='$id'{sum+=$3; cnt++} 
			END {printf "average rating of %s : %.6g\n",'$id',sum/cnt}'
		;;
	4)
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) : " ans
		echo
		if [ $ans = "y" ]
		then
			cat $1 | sed -E 's/http[^|]*//g' | head
		fi
		;;
	5)	read -p "Do you want to get the data about users from 'u.user'?(y/n) : " ans
		echo
		if [ $ans = "y" ]
		then
			cat $3 | sed -E -e 's/M/male/' -e 's/F/female/' | 
				sed -E 's/([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|(.*)/user \1 is \2 years old \3 \4/' |
			       	head
		fi
		;;
	6)	
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n) : " ans
		echo
		if [ $ans = "y" ]
		then
			cat $1 | sed -E -e 's/-Jan-/-01-/' -e 's/-Feb-/-02-/' -e 's/-Mar-/-03-/' -e 's/-Apr-/-04-/' \
				-e 's/-May-/-05-/' -e 's/-Jun-/-06-/' -e 's/-Jul-/-07-/' -e 's/-Aug-/-08-/' \
				-e 's/-Sep-/-09-/' -e 's/-Oct-/-10-/' -e 's/-Nov-/-11-/' -e 's/-Dec-/-12-/' | 
				sed -E 's/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/' | tail
		fi
		;;
	7)
		read -p "Please enter the 'user id'(1~943) : " id
		echo
		mid=$(cat $2 | awk '$1=='$id'{print $2}' | sort -n)
		echo $mid | sed -E 's/ /\|/g'
		echo $'\n'
		mid=$(echo $mid | cut -d" " -f-10)
		for var in $mid
		do	
			awk -F\| '$1=='$var'{print $1"|"$2}' $1
		done
		;;
	8)	
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) : " ans
		echo
		if [ $ans = "y" ]
		then
			data=$(mktemp data_XXXX.txt)
			uid=$(cat $3 | awk -F\| '$2>19 && $2<30 && $4=="programmer"{print $1}')
			for var in $uid
			do
				awk '$1=='$var'{print $2, $3}' $2 >> $data
			done
			for var in $(seq 1682)
			do
				awk '$1=='$var'{sum+=$2; cnt++} 
				END {if(cnt!=0) printf "%s %.6g\n", '$var', sum/cnt}' $data
			done
			rm $data
		fi
		;;
	9)	
		echo "Bye!"
		break
		;;
	esac
	echo 
done
