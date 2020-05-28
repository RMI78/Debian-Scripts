#!/bin/bash

printf 'welcome in this script that automate your scans on a HP printer, please make sure to read the README.md before and install all the required dependencies to avoid any errors \n'
current_dir=$(pwd)
#for errors handling
set -e


######GUIDED INPUT MODE#######
read -p 'How many scans will you do: ' scan_number
read -p 'Set the delay (in seconds) needed to switch between scans: ' delay
read -e -p 'Set the absolute path folder (without aliases) where you want to save your files: ' path_file
echo $path_file
if [ ! -d $path_file ]; then
  read -p 'this directory does not exist, do you want to create it ? (y for yes, n for no): ' create_dir
  if [ $create_dir = 'y' ];then
    mkdir $path_file
    printf 'File created at $create_dir \n'
  else
    printf 'ok, exiting...\n'
    exit
  fi
fi
cd $create_dir
read -n 4 -p 'What output files do you want ? (pdf for PDF file(s), pdfu for an united pdf file , anything else for the default png format): ' output_format
printf '\n'
if [ $output_format = 'pdfu' ];then
  read -p 'Name this final PDF file (do not forget to add ".pdf" at the end of the name): ' unified_pdf_file
fi


######CHECKING PART######
if [ $scan_number = '0' ];then
  printf 'no scan needed, quit'
  exit
fi
if [ $output_format != 'pdf' ] && [ $output_format != 'pdfu' ];then
  printf 'unknow format, switching to default png format\n'
  output_format='png'
fi
if [ $scan_number = '1' ] && [ $output_format = 'pdfu' ];then
  printf 'only 1 scan programmed, no pdfu format needed, switching to pdf format\n'
  output_format='pdf'
fi

#######MAIN PART#########
printf 'get ready, the scan process will start... \n'
for i in `seq 1 $scan_number`; do
  for j in `seq 0 $delay`;do
    printf $(expr $delay - $j)' seconds left before the next scan'
    sleep 1
    printf '\r'
  done
    printf '\n'
    scanimage --mode Color --format png -p >hp$i.png
    printf '\r\r'
done
printf '\n'
if [ $output_format = 'pdfu' ];then
  tmp_pdf_file=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '').pdf
  convert hp*.png $tmp_pdf_file
  printf "compressing pdf..."
  ps2pdf $tmp_pdf_file $unified_pdf_file
  rm $tmp_pdf_file hp*.png
fi
cd $current_dir
printf 'job done !\n'
