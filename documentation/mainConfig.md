# mainConfig

Configuration file for running the gaitAnalyzer code. Here, certain variables are defined by the user, which are then passed into
the code. The types of variables defined here are divided into three groups : fileinputs, configinputs, and markerstrings.

# fileinputs
fileinputs deals with variables for defining how to run the symmetry analsysi. Variables here dictate which files to read in, whether to run a symmetry analysis on the gait parameters, and define string keywords for the different trialfiles for which to run a symmetry analysis for.
 - **file_select**  decide quantity of files to run
   - *select* :  run code for only one user-chosen data file
   - *all* : run code for all files with the given file extension (default)
 -  **run_symmetry** : bool for deciding wheter to run symmetry analysis (1 - run, 0 - don't run)
 -  **paretic** : string keyword for your trialfiles containing paretic trialwalks (matched w/ regexp) 
   - ex. if your prosthetic gait trialfiles are named *Test_PSLow_1.txt* and *Test_PSLow_2.txt*, use *paretic=PSLow*)
 -  **nonparetic** : string keyword for your trialfiles containing nonparetic trialwalks (matched w/ regexp) 
   - ex. if your normal gait trialfiles are named *Test_NW_1.txt* and *Test_NW_2.txt*, use *nonparetic=NW*)

   





 -  ** run_symmetry** : bool for toggling forward walking direction is in a positive or negative coordinate direction
   - __ 1__ : 
