procFile=.procFile
procDir=.procDir
docker stats --no-stream $(docker ps --format '{{.Names}}') | tail -n +2 > $procFile 
if ! [[ -d "$procDir" ]];
then
    mkdir $procDir
fi
rm -f $procDir/*
while read line
do
    name=$(echo $line | awk '{print $1}')
    proc=$(echo $line | awk '{print $2}' | cut -d '.' -f1)
    echo $proc > "$procDir/$name"
done < $procFile
rm -f $procFile
