# mainConfig

last edited : 31dec2015

---

Configuration file for running the gaitAnalyzer code. Here, certain variables are defined by the user, which are then passed into the code. The types of variables defined here are divided into three groups : fileinputs, configinputs, and markerstrings.

---
# fileinputs
fileinputs deals with variables for defining how to run the symmetry analsysi. Variables here dictate which files to read in, whether to run a symmetry analysis on the gait parameters, and define string keywords for the different trialfiles for which to run a symmetry analysis for.
 - **file_select** : decide quantity of files to run.
   - *select* :  run code for only one user-chosen data file.
   - *all* : run code for all files with the given file extension (default).
 -  **run_symmetry** : bool for deciding wheter to run symmetry analysis (1 - run, 0 - don't run).
 -  **paretic** : string keyword for your trialfiles containing paretic trialwalks (matched w/ regexp) .
   - ex. if your prosthetic gait trialfiles are named *Test_PSLow_1.txt* and *Test_PSLow_2.txt*, use *paretic=PSLow*).
 -  **nonparetic** : string keyword for your trialfiles containing nonparetic trialwalks (matched w/ regexp).
   - ex. if your normal gait trialfiles are named *Test_NW_1.txt* and *Test_NW_2.txt*, use *nonparetic=NW*).

--- 

# configinputs
configinputs deals with general variables concerning data processing and parameter thresholds.
 - **txt_idx** : specify which columns in your datafile contain marker and force data, not frame/time data.
   - specifying *txt_idx=default* will automatically grab the marker and force data. However, the column with raw frame data must have the string *Frame* and the column with raw time data must have the string *Time*.
   - note : only *default* has been tested; numerical inputs have not yet been tested.
 - **frame_idx** : column index with frame data (not sure if *txt_idx* overrides this).
 - **time_idx** : same as frame_idx, except for time data (same question).
 - **ignore_idx** : combines *frame_idx* and *time_idx*.
 - **frequency** : set the frequency of your cameras (number of frames per second).
 - **threshold** : set threshold (in Newtons) for registering whether there is sufficient force to consider a stance time Default value of 5 has been seen to work so far, but can be changed.
 - **forward_bool** : bool for toggling forward walking direction is in a positive or negative coordinate direction (1 - forward is positive. 0 - forward is negative).
 - **LFB** : lower force bound for determining gaitcycles (default 5N shows to work well).
 - **UFB** : upper force bound for determining gaitcycles (default 100N shows to work well).
 - **gc_percent** : percentage of each gaitcycle you wish to include in your gaitcylce vectors for each parameter. Inputs go in decimal format (ex. 1 = 100%, 0.67 = 67%, 1.5 = 150%).
 - **prosthesis** : mass of your total prosthetic (if running paretic trials) (kg).
 - **p_calf** : mass of the prosthetic calf/shank (kg).
 - **p_foot** : mass of the prosthetic foot (kg).

---
Note that for the following direction variables to function, the titles in the raw files for the markers and forces must contain that string keyword (regexp is being used to match values).
 **Ex** if *forward_marker = X*, then all marker columns concerning forward movement must have the string *X* in the column     title (such as *LHEE.X*, *NAVE.X*, *RTOE.X*, etc). Like for forces : if *vertical_force = Y*, then vertical force values       should have titles such as *FP1.Y*, *FP2.Y*.
 -  **forward_marker** : define the Cartesian forward direction for the marker coordinate system.
 -  **vertical_marker** : define the Cartesian vertial direction for the marker coordinate system.
 -  **lateral_marker** : define the Cartesian lateral direction for the marker coordinate system.
 -  **forward_force** : define the Cartesian forward direction for the force coordinate system.
 -  **vertical_force** : define the Cartesian vertial direction for the force coordinate system.
 -  **lateral_force** : define the Cartesian lateral direction for the force coordinate system.

---

# markerstring

markersting deals with defining the markers for which certain body joints are required for running different gait parameter functions.
 - **sacr_str** : define string keyword for the sacrum datamarker
 - **nave_str** : define string keyword for the navel datamarker
 - **llek_str** : define string keyword for the left knee datamarker
 - **rlek_str** : define string keyword for the right knee datamarker
 - **llm_str** : define string keyword for the left ankle datamarker
 - **rlm_str** : define string keyword for the right ankle datamarker
 - **lgtro_str** : define string keyword for the left hip datamarker
 - **rgtro_str** : define string keyword for the right hip datamarker
 - **ltoe_str** : define string keyword for the left toe datamarker
 - **rtoe_tr** : define string keyword for the right toe datamarker
 - **lhee_str** : define string keyword for the left heel datamarker
 - **rhee_str** : define string keyword for the right heel datamarker
 - **fp1_str** : define string keyword for the first forceplate (assuming left side)
 - **fp2_str** : define string keyword for the second forceplate (assuming right side)

---
