#!/bin/bash
set -e

###FUNCTION SECTION###
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
  echo "${1:$first_index:$last_index-$first_index}"
  return 0
}


function get_max_space(){
  #take an array in parameters
  #return the maximum lenghts of each items of the array
  copy=("$@")
  max_lenght=0
  for item in "${copy[@]}";do
    if [ "${#item}" -gt "$max_lenght" ];then
      max_lenght=${#item}
    fi
  done
  let max_lenght+=1
  printf "$max_lenght"
}

#####MAIN CODE#####

current_device="$(nmcli connection show --active | tail -n1  | awk 'NF{ print $1;}')"

##CHECKING INTERNET CONNECTION##
nmcli con mod $current_device ipv4.ignore-auto-dns yes
ping servers.oopennic.org -c 1 > /dev/null
if [ $? -gt 0 ];then
  printf 'You seem to have issues with your DNS or your internet connection, make sure you are connected, configuring your temporary DNS on 1.1.1.1 ...\n'
  nmcli con mod $current_device ipv4.dns 1.1.1.1
fi

##SCRAPPING AND PARSING PART##
printf 'Welcome to the AODNS script, it will fetch the no logs DNS from the Opennic project and install one of them.\n'
#crawling the website and applying a first filter then store it into a txt file for a better work
curl -k -s https://servers.opennic.org | grep "No logs kept" | grep "Pass" > crawled_content.txt
#storing each lines of the crawled content into a bash array and removing unwanted elements
while IFS='' read -r line || [[ -n "$line" ]];do
  #removing empty trailing spaces
  filtered_line=$(echo $line | xargs)
  raw_server_list+=("$filtered_line")
done < crawled_content.txt
rm crawled_content.txt

#scrapping content
for index in ${!raw_server_list[*]};do
  current_line="${raw_server_list[$index]}"
  ipv4_list+=($(extract_tag_content "$current_line" "class=mono ipv4"))
  #some tags remain in the scrapped ipv6 list which require a little more work and some ipv6 aren't available so they will be replaced with "NONE"
  tmp_ipv6=$(printf "$(extract_tag_content "$current_line" "class=mono ipv6")" | sed -e "s/<wbr>//g")
  if [ "$tmp_ipv6" = "&nbsp;" ];then
    ipv6_list+=("NONE")
  else
    ipv6_list+=($tmp_ipv6)
  fi
  #tags remain in the scrapped hostname list which require a little more work
  tmp_hostname=$(extract_tag_content "$current_line" "a id=")
  hostname_list+=($(printf $tmp_hostname | sed 's/<br><em>.*//g'))
  subm_date_list+=($(extract_tag_content "$current_line" "class=crtd"))
  #a tag remain in the scrapped owner list which require a little more work
  tmp_owner="$(extract_tag_content "$current_line" "class=ownr")"
  owner_list+=("${tmp_owner:0:${#tmp_owner}-4}")
done


##PRINTING THE DNS TO THE USERS##


#getting the lenght of each arrays
lenght_ipv4="$(get_max_space "${ipv4_list[@]}")"
lenght_ipv6="$(get_max_space "${ipv6_list[@]}")"
lenght_hostname="$(get_max_space "${hostname_list[@]}")"
lenght_owner="$(get_max_space "${owner_list[@]}")"

printf "the following DNS have been scrapped from the Opennic servers.\nIn the following order: ipv4, ipv6, hostname, owner, submission-date\n"
for index in ${!raw_server_list[*]}
do
    printf "$index   "
    for i in `seq 0 $(expr 3 - ${#index})`;do
      printf " "
    done
    printf "${ipv4_list[$index]}   "
    for i in `seq 0 $(expr $lenght_ipv4 - ${#ipv4_list[$index]})`;do
      printf " "
    done
    printf "${ipv6_list[$index]}   "
    for i in `seq 0 $(expr $lenght_ipv6 - ${#ipv6_list[$index]})`;do
      printf " "
    done
    printf "${hostname_list[$index]}   "
    for i in `seq 0 $(expr $lenght_hostname - ${#hostname_list[$index]})`;do
      printf " "
    done
    printf "${owner_list[$index]}   "
    for i in `seq 0 $(expr $lenght_owner - ${#owner_list[$index]})`;do
      printf " "
    done
    printf "${subm_date_list[$index]}\n"
done
printf "which one would you like to install ? [0-$(expr ${#raw_server_list[@]} - 1)]"
read dns_number
printf "getting your first current device used to be connected to internet\n"
printf "setting the DNS to the device...\n"
nmcli con mod $current_device ipv4.dns "${ipv4_list[$dns_number]}"
printf "done !\n"
