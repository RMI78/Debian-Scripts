# BashBackground
A simple shell script who change your background on Gnome 

## How to Use 

1.Create a new folder named Wallpapersin the Pictures folder of your home:
`mkdir ~/Pictures/Wallpapers/`


2.Place all your wallpapers in the folder

3.Start the script from a shell:

`./BashBackground.sh`

> You can also start it in background by using '&' char at every boots or cron tabs in order to set it as a daemon:

`./BashBackground.sh &`

> or 

`crontab -e`

> and in the crontab file, add the lines:

`@reboot /path/to/BashBackground.sh`



