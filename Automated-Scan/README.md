# Automated HP Scan

If you have an HP printer/scanner, this script could save you some repetitive scanning and conversion tasks

## How to use

For the moment, the input system is fully guided, just run it and let the script guide you.
By switching from hp-scan to scanimage command, the user can now scan from any printer regardless the brand as SANE allow more generic using. hplip is, meanwhile, always required
The dependency pdfunite is no longer required, see 'Requirements' for further informations.

## Requirements

In order to run this script you will need to have :
* The following dependencies: ps2pdf, ImageMagick, SANE, and hplip
* A Cups daemon running
* An HP printer already paired with your computer (to set up an HP printer, install the hplip package and see the hp-setup command)

## To-Do List
* Install a parameter mode so the advanced users can avoid the guided mode by inserting parameters
* Allow multiple conversion into different formats
* ask for an auto setup of the printer if any printed is detected and set by default
* insert enough printf carriage return to make the script fully dynamic
* ~~Allow aliases input for path file~~ couldn't be done properly, in the meantime auto-completion from bash shell has been added
* Add a beggining timer so the user can access to an away scanner
