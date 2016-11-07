
flows=5
pop_selection=2
COUNTER=0
until [  $COUNTER -ge 1 ]; 
do
    for dos in 2 
    do
        python topology.py --flows=$flows --dos=$dos
        for file in Plugo/*.xml
        do
            bash leap.sh $file >> Results/PS${pop_selection}D${dos}F${flows}.dat
            rm -rf $file 
        done
    done
    let COUNTER+=1
done
