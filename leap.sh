QoECalc (){
    start=$1
    stcount=$2
    stlen=$3
    lambda=$(bc -l <<< "$stlen / ($stlen + 60)")
    if [ "$(bc -l <<< "$stcount > 6")" -eq 1 ]
    then
        qoe=1
        return
    fi
    if [ "$(bc -l <<< "$lambda < 0.05")" -eq 1 ]
    then
        a=3.012682983
        b=0.765328992
        c=1.991000000
    elif [ "$(bc -l <<< "$lambda < 0.1")" -eq 1 ]
    then
        a=3.098391523
        b=0.994413063
        c=1.901000000
    elif [ "$(bc -l <<< "$lambda < 0.2")" -eq 1 ]
    then
        a=3.190341904
        b=1.520322299
        c=1.810138616
    elif [ "$(bc -l <<< "$lambda < 0.5")" -eq 1 ]
    then
        a=3.248113258
        b=1.693893480
        c=1.751982415
    elif [ "$(bc -l <<< "$lambda > 0.5")" -eq 1 ]
    then
        a=3.302343627
        b=1.888050118
        c=1.697472392
    fi

    qoe=$(bc -l <<< "scale=3;$a *e(-$b*$stcount) +$c");
    #return $qoe;
}
parsePlugo (){
    file=$1
    total_stall_length=$(xmllint --xpath '/test/total_stall_length/text()' $file)
    total_stall_number=$(xmllint --xpath '/test/total_number_of_stall/text()' $file)
    total_playtime=$(xmllint --xpath '/test/total_played_time/text()' $file)
    coef=$(bc <<< "scale=6;$total_playtime/60")
    if [ "$(bc -l <<< "$coef < 0.01")" -eq 1 ]
    then
        echo "1"
    else
        stall_count=$(bc <<< "$total_stall_number/$coef")
        stall_length=$(bc <<< "$total_stall_length/$coef")

        QoECalc 0 $stall_count $stall_length
        echo $qoe

    fi
    #echo "calling: 0 $stall_count $stall_length"
}
parsePlugo $1
