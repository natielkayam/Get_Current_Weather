#!/bin/bash
#enviroment varibale to the c# aplication to get the current weather
GET_CURRENT_WEATHER_BIN=./get_current_weather

# function that calls my c# program to get only the temp for spesific city
function get_temp() {
  OUTPUT=$(echo $city '('$($GET_CURRENT_WEATHER_BIN --city $city --units metric | cut -d '|' -f 2 )')')
  echo $OUTPUT >> ./tmp-OUTPUTS
}

#get the city from the txt file and activate get_temp func
while read city
do
 get_temp &
done < /dev/stdin
wait

cat ./tmp-OUTPUTS | tr -d '\r' | sort -rnt'(' -k2 | head -n3 > ./tmp-OUTPUTS-sorted
readarray -t TOP < ./tmp-OUTPUTS-sorted

for((i=1;i<=${#TOP[@]};i++)); do
  echo ${i}. ${TOP[${i} - 1]}
done

rm -f ./tmp-OUTPUTS ./tmp-OUTPUTS-sorted
