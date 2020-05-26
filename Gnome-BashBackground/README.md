# BashBackground
A simple shell script which change your background on Gnome

## What's New ?
BashBackground have been renamed to Gnome-BashBackground (because it... basically run with Gnome only, that seems obvious) and don't need to have a running script anymore, since it runs on top of Cron you can now just start the install.sh script to make your background wallpaper changing peristent, no dependencies are required

## How to Use

### Install
Just launch the install.sh script and let it guide you through the very short installation, after that you can even remove the git from your computer as changes are persistent, it will not affect the process

### Remove

A removing script is useless, to get back to a constant background open your crontab with `crontab -e` then remove the line that start with _\*/(the minute you set) \* \* \* \* PID=$(..._

## Requirements

Your system need to have a Gnome interface and the script will use the `cron` program 

## Troubleshooting

You can't run the install.sh script:
just use `chmod +x install.sh`

The background doesn't change after the installation:
This bug happens sometimes due to a wrong PID, this bug may be patched later, in the meantime you can still correct this by going to your crontab with `crontab -e` then going to the line that start with _\*/(the minute you set) \* \* \* \* PID=$(..._ and changing the word `tail` to `head`

You want to change the frequency:
go to your crontab with `crontab -e` then go to the line that start with _\*/(the minute you set) \* \* \* \* PID=$(..._ and change the number representing the frequency minute
