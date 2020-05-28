#!/bin/bash

printf 'welcome in this script that automate your scans on a HP printer, please make sure to read the README.md before and install all the required dependencies to avoid any errors \n'
current_dir=$(pwd)
######GUIDED INPUT MODE#######
read -p 'How many scans will you do: ' scan_number
read -p 'Set the delay (in seconds) needed to switch between scans: ' delay
read -p 'Set the absolute path folder (without aliases) where you want to save your files: ' path_file
if [ ! -d $path_file ]; then
  read 'this directory does not exist, do you want to create it ? (y for yes, n for no): ' create_dir
  if [ $create_dir = 'y' ];then
    mkdir $path_file
    printf 'File created at $create_dir \n'
  else
    printf 'ok, exiting...\n'
    exit
  fi
fi
cd $create_dir
read -p 'What output files do you want ? (pdf for an unified PDF file, anything else for the default png format): ' output_format
if [ $output_format = 'pdf' ];then
  read -p 'Name this final PDF file (do not forget to add ".pdf" at the end of the name): ' unified_pdf_file
fi


#######MAIN PART#########
printf 'get ready, the scan process will start... \n'
for i in `seq 1 $scan_number`; do
  for j in `seq 0 $delay`;do
    printf $(expr $delay - $j)' seconds left before the next scan'
    sleep 1
    printf \\r
  done
    hp-scan
done
if [ $output_format = 'pdf' ];then
  tmp_pdf_file=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '').pdf
  convert hp*.png $tmp_pdf_file
  printf "compressing pdf..."
  ps2pdf $tmp_pdf_file $unified_pdf_file
  rm $tmp_pdf_file hp*.png
fi
cd $current_dir
printf 'job done !\n'
