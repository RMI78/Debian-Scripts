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
  #extract content from converted string with an html partial or full tag given in parameters
  index=$(index_substr_from_str "$1" "$2")
  if [ "$index" = "-1" ];then
    echo ""
    return 0
  fi
  first_index=$index
  while [ "${1:$first_index:1}" != ">" ];do
    let first_index+=1
  done
  last_index=$first_index
  while [ "${1:$last_index:2}" != "</" ];do
    let last_index+=1
  done
  let first_index+=1
  echo ${1:$first_index:$last_index-$first_index}
  return 0
}

#crawling the website and applying a first filter then store it into a txt file for a better work
curl -s https://servers.opennic.org | grep "No logs kept" | grep "Pass"   > crawled_content.txt
#storing each lines of the crawled content into a bash array and removing unwanted elements
while IFS='' read -r line || [[ -n "$line" ]];do
  #removing empty trailing spaces
  filtered_line=$(echo $line | xargs)
  raw_server_list+=("$filtered_line")
done < crawled_content.txt
rm crawled_content.txt
for index in ${!raw_server_list[*]};do
  current_line="${raw_server_list[$index]}"
  ipv4_list+=$(extract_tag_content "$current_line" "class=mono ipv4")
  #some tags remain in the scrapped ipv6 list which require a little more work
  tmp_ipv6=$(extract_tag_content "$current_line" "class=mono ipv6")
  ipv6_list+=$(printf "$tmp_ipv6" | sed -e "s/<wbr>//g")
  hostname_list+=$(extract_tag_content "$current_line" "a id=")
  subm_date_list+=$(extract_tag_content "$current_line" "class=crtd")
  #a tag remain in the scrapped owner list which require a little more work
  tmp_owner=$(extract_tag_content "$current_line" "class=ownr")
  owner_list+=${tmp_owner:0:${#tmp_owner}-4}
done


for ix in ${!ipv6_list[*]}
do
    echo "${ipv6_list[$ix]}\n"
done
echo
