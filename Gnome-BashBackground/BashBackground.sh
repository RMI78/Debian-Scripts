#!/bin/bash
wall_dir="/home/$USER/Pictures/Wallpapers"
printf "starting the installation...\n the default directory to put your wallpapers is $wall_dir \n"
read -p "do you want to change it ? (y for yes, n for no)" change_dir
if [ $change_dir = 'y' ];then
  read -p "Enter the absolute path directory where you want to put you Wallpapers(leave empty for the default /home/$USER/Pictures/Wallpapers): " wall_dir
fi

read -p "enter a changing interval in minutes(between 0 and 59): " min

if [ ! -d $wall_dir ];then
  mkdir $wall_dir
  printf "a directory was created at $wall_dir"
fi


(crontab -l 2>/dev/null; echo '*/'$min' * * * * PID=$(pgrep gnome-session | tail -n1 ) && export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-) && gsettings set org.gnome.desktop.background picture-uri "file://"$(find '$wall_dir' -type f | shuf -n 1)') | crontab -

printf "installation done !\n"
