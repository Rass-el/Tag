#!/bin/bash
function greet {
	clear
	printf "Добро пожаловать в Пятнашки!"
	sleep 1000000
}

function init {
	k=$(($1*$1-1))
	for ((i=0; i < $1; i++))
	do      
		for ((j=0; j < $1; j++))
                do     
                	board[$i$j]=$k
			k=$(($k-1))
                done    
  	done
	

	if [[ "$1" -eq "2" ]]
	then
		p=${board[$(($1-1))$(($1-2))]}
                board[$(($1-1))$(($1-2))]=${board[$(($1-2))$(($1-1))]}
                board[$(($1-2))$(($1-1))]=$p
		return
       	fi

	if [[ "($1*$1)%2" -eq "0" ]]
	then
		p=${board[$(($1-1))$(($1-2))]}
        	board[$(($1-1))$(($1-2))]=${board[$(($1-1))$(($1-3))]}
        	board[$(($1-1))$(($1-3))]=$p
	fi
}

function draw {
	clear
	for ((i=0; i < $1; i++))
	do
		for ((k=0; k < 6*$1; k++))
		do
			echo -en '\xE2\x95\x90'
		done
       		printf "\n"
		for ((j=0; j < $1; j++))
		do
			if ((${board[$i$j]} != 0))
			then
				echo -en '\xE2\x95\x91 '
                		printf "%-2d" ${board[$i$j]}
				echo -en ' \xE2\x95\x91'
            		else   
				echo -en '\xE2\x95\x91    '
				echo -en '\xE2\x95\x91'
			fi
		done
        	printf "\n"
		for ((k=0; k < 6*$1; k++))
		do
			echo -en '\xE2\x95\x90'
            		#printf "%6s" "____"
		done
        	printf "\n"
    	done
}

#1-м аргументом передается размерность поля
#2-м аргументом передается значение перемещающейся ячейки
function move {
	for ((i=0; i < $1; i++))
	do
		for ((j=0; j < $1; j++))
		do
			if ((${board[$i$j]} <= 0))
			then
				i1=$i
				j1=$j
			fi
			if [[ "${board[$i$j]}" -eq "$2" ]]
			then	
				i2=$i
				j2=$j
			fi
		done
	done
	if [[  "($i1-$i2)**2" -eq "1" && "($j1-$j2)**2" -eq "0" || "($i1-$i2)**2" -eq "0" && "($j1-$j2)**2" -eq "1" ]] 
	then

		board[$i1$j1]=${board[$i2$j2]}
		board[$i2$j2]=0 
		return 0 
	fi
	return 1
}

#параметром передается размерность поля
function won {
	p=1
	for ((i=0; i < $1; i++))
	do
		for ((j=0; j < $1; j++))
		do
			if [[ ("${board[$i$j]}" -ne "$p") && ("$p" -ne "$1*$1") ]]
			then
                		return 0
			fi
			p=$(($p+1))
    		done
    	done

	echo "UWIN!!!"
	return 1
}

function check {
	return $1
} # ЕДИНИЦА ЭТО FALSE 
declare -a board              #создание пустого индексируемого массива
if [ -z $1 ] 
then
	echo "Usage: ./main.sh number"
else
	init $1
	draw $1
	while won $1
	do
		read turn
		move $1 $turn
		draw $1
	done
fi

exit 0
