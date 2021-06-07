#!/bin/sh

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

RES_PATH=/storage/self/primary/Documents/results
TRASH_PATH=/storage/self/primary/Documents/trash

governor=$1
max=$2
N=$3
m=$4
usage="Usage: sh synthmark_bench.sh [ performance_with_idle|performance_without_idle|schedutil_with_idle|schedutil_without_idle ] [ iteration ] [ -N(value) optional ] [ -m(l|r|s) optional] \nExample: sh synthmark_bench.sh performance_with_idle 5 -N100 -ms"
case $governor in
    performance_with_idle|performance_without_idle|schedutil_with_idle|schedutil_without_idle) echo Start with $governor test;;
    *)             echo "param error, $usage"; exit;
esac

if ! [ -f "$governor.sh" ]; then
    echo "$governor.sh no such file, please insert it in the same path of this script"
    exit
fi

if ! [ -f "powersave.sh" ]; then
    echo "powersave.sh no such file, please insert it in the same path of this script"
    exit
fi

case $max in
	1|2|3|4|5|6|7|8|9|10) echo number iteration: $max;;
	*)	echo "Iteration param error [1..10]"; exit; 
esac

if ! [[ $N == "-N"* || $N == "" ]]; then
  echo $usage
  exit
fi

case $m in
	-mr|-ml|-ms|"");;
	*)	echo $usage; exit;
esac

sh $governor.sh
echo "Start test in $governor mode" >> $RES_PATH/out.txt
echo -n "\n" >> $RES_PATH/out.txt

if [ -f "$RES_PATH/out.txt" ]; then
    rm $RES_PATH/out.txt
    echo "Initialized file results"
fi

i=1
tot_test=$((max * 3))
max=`expr $max + 1`
while [ $i -lt $max ]
do
	start=`date +%s`
	echo "./synthmark -tl -n5 $N $m"
	./synthmark -tl -n5 $N $m > $TRASH_PATH/5sN.txt
	end=`date +%s`
	runtime=$((end-start))
	echo -n "Duration " >> $RES_PATH/out.txt
	echo -n $runtime >> $RES_PATH/out.txt
	echo -n "  " >> $RES_PATH/out.txt
	tail -n15 $TRASH_PATH/5sN.txt > $RES_PATH/5sN.txt
	echo -n "5sN " >> $RES_PATH/out.txt
	echo -n $(head -n4 $RES_PATH/5sN.txt | tail -n1 | tail -c$(head -n4 $RES_PATH/5sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n " " >> $RES_PATH/out.txt
	echo -n $(head -n5 $RES_PATH/5sN.txt | tail -n1 | tail -c$(head -n5 $RES_PATH/5sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n " " >> $RES_PATH/out.txt
	echo -n $(head -n6 $RES_PATH/5sN.txt | tail -n1 | tail -c$(head -n6 $RES_PATH/5sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n "\n" >> $RES_PATH/out.txt

	ntest=`expr $((i * 3)) - 2`
	perc=$((ntest * 100 / tot_test)) 
	echo "Iteration $i [OK] [$perc%]"
	sleep 1m

	start=`date +%s`
	echo "./synthmark -tl -n50 $N $m"
	./synthmark -tl -n50 $N $m > $TRASH_PATH/50sN.txt
	end=`date +%s`
	runtime=$((end-start))
	echo -n "Duration " >> $RES_PATH/out.txt
	echo -n $runtime >> $RES_PATH/out.txt
	echo -n "  " >> $RES_PATH/out.txt
	tail -n15 $TRASH_PATH/50sN.txt > $RES_PATH/50sN.txt
	echo -n "50sN " >> $RES_PATH/out.txt
	echo -n $(head -n4 $RES_PATH/50sN.txt | tail -n1 | tail -c$(head -n4 $RES_PATH/50sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n " " >> $RES_PATH/out.txt
	echo -n $(head -n5 $RES_PATH/50sN.txt | tail -n1 | tail -c$(head -n5 $RES_PATH/50sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n " " >> $RES_PATH/out.txt
	echo -n $(head -n6 $RES_PATH/50sN.txt | tail -n1 | tail -c$(head -n6 $RES_PATH/50sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n "\n" >> $RES_PATH/out.txt

	ntest=`expr $((i * 3)) - 1`
	perc=$((ntest * 100 / tot_test)) 
	echo "Iteration $i [OK] [$perc%]"
	sleep 1m

	start=`date +%s`
	echo "./synthmark -tl -n100 $N $m "
	./synthmark -tl -n100 $N $m> $TRASH_PATH/100sN.txt
	end=`date +%s`
	runtime=$((end-start))
	echo -n "Duration " >> $RES_PATH/out.txt
	echo -n $runtime >> $RES_PATH/out.txt
	echo -n "  " >> $RES_PATH/out.txt
	tail -n15 $TRASH_PATH/100sN.txt > $RES_PATH/100sN.txt
	echo -n "100sN " >> $RES_PATH/out.txt
	echo -n $(head -n4 $RES_PATH/100sN.txt | tail -n1 | tail -c$(head -n4 $RES_PATH/100sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n " " >> $RES_PATH/out.txt
	echo -n $(head -n5 $RES_PATH/100sN.txt | tail -n1 | tail -c$(head -n5 $RES_PATH/100sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n " " >> $RES_PATH/out.txt
	echo -n $(head -n6 $RES_PATH/100sN.txt | tail -n1 | tail -c$(head -n6 $RES_PATH/100sN.txt | tail -n1 | expr $(wc -c) - 23)) >> $RES_PATH/out.txt
	echo -n "\n" >> $RES_PATH/out.txt
	
	ntest=`expr $((i * 3)) - 0`
	perc=$((ntest * 100 / tot_test)) 
	echo "Iteration $i [OK] [$perc%]"
	sh powersave.sh
	sleep 1m
	sh $governor.sh
 	true $(( i++ ))
done
echo "Done"
sh powersave.sh
cat $RES_PATH/out.txt
