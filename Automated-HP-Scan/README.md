#Automated HP Scan

If you have an HP printer/scanner, this script could save you some repetitive scanning and conversion tasks

##How to use

For the moment, the input system is fully guided, just run it and let the script guide you

##Requirements

In order to run this script you will need to have :
* The following dependencies: pdfunite, ps2pdf, and hplip
* A Cups daemon running
* An HP printer already paired with your computer (to set up an HP printer, install the hplip package and see the hp-setup command)

##To-Do List
* Secure the read input by checking types
* Install a parameter mode so the advanced users can avoid the guided mode by inserting parameters
* Allow multiple conversion into different formats
* ask for an auto setup of the printer if any printed is detected and set by default
* insert enough printf carriage return to make the script fully dynamic
* Allow aliases input for path file
 
