#!/bin/sh
RES_PATH=/storage/self/primary/Documents/results
TRASH_PATH=/storage/self/primary/Documents/trash

governor=$1
max=$2
usage="usage: sh synthmark_bench.sh [ performance_with_idle|performance_without_idle|schedutil_with_idle|schedutil_without_idle ] [ iteration ]"
case $governor in
    performance_with_idle|performance_without_idle|schedutil_with_idle|schedutil_without_idle) echo Start with $governor test;;
    *)             echo "param error, $usage"; exit;
esac

case $max in
	1|2|3|4|5|6|7|8|9|10) echo number iteration: $max;;
	*)	echo "iteration param error [1..10]"; exit; 
esac



sh $governor.sh
echo "start test in $governor mode" >> $RES_PATH/out.txt
echo -n "\n" >> $RES_PATH/out.txt

i=1
tot_test=$((max * 3))
max=`expr $max + 1`
while [ $i -lt $max ]
do
	start=`date +%s`
	./synthmark -tl -n5 -N100 -b64 > $TRASH_PATH/5sN.txt
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
	echo "iteration $i test 5Ns [OK] [$perc%]"
	sleep 1m

	start=`date +%s`
	./synthmark -tl -n50 -N100 -b64 > $TRASH_PATH/50sN.txt
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
	echo "iteration $i test 50Ns [OK] [$perc%]"
	sleep 1m

	start=`date +%s`
	./synthmark  -tl -n100 -N100 -b64 > $TRASH_PATH/100sN.txt
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
	echo "iteration $i test 100Ns [OK] [$perc%]"
	sh powersave.sh
	sleep 1m
	sh $governor.sh
 	true $(( i++ ))
done
echo "Done"
sh powersave.sh
cat $RES_PATH/out.txt

