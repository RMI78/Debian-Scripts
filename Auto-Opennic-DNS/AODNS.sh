#!/bin/bash
printf 'Welcome to the AODNS script, it will fetch the more secured and reliable free DNS from the Opennic project install them.\nDo not hesitate to run this script again if you have network issues, those DNSs can sometimes be capricious\n'

function index_substr_from_str () {
  #get the last index of the first occurence of a given substring supposed to be in a string
  #first parameter should be the string, second parmater should be the substring to seek
  #return -1 if the substring isn't found
  substr_len=${#2}
  integrity=0
  j=-1
  for i in `seq 0 ${#1}`;do
    if [ "${2:$integrity:1}" = "${1:i:1}" ];then
      let integrity+=1
    else
      integrity=0
    fi
    if [ $integrity = $substr_len ];then
      j=$i
    fi
  done
  echo $j
}

function extract_tag_content(){
  #extract content from html tag converted in a string 
}

#crawling the website and applying a first filter then store it into a txt file for a better work
curl -s https://servers.opennic.org | grep "No logs kept" | grep "Pass"   > crawled_content.txt
#storing each lines of the crawled content into a bash array and removing unwanted elements
while IFS='' read -r line || [[ -n "$line" ]];do
  #removing empty trailing spaces
  filtered_line=$(echo $line | xargs)
  #removing the Pass word
  filtered_line=${filtered_line:0:-4}
  if [[ $filtered_line = '&#'* ]];then
    #removing the specials caracters when they exist
     filtered_line=${filtered_line:7}
  fi
  raw_server_list+=("$filtered_line")
done < crawled_content.txt


for ix in ${!raw_server_list[*]}
do
    echo "${raw_server_list[$ix]}\n"
done
echo
