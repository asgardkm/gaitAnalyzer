# gaitAnalyzer
Description : MATLAB code for gait analysis of a research subject's recorded marker coordinates and forceplate values of a trial walk.
Hello! This is my first proper programming project, as well as my first project on GitHub, so this page may not be yet as refined
as it could be (please bear with me :))

This code was written in order to analyze the gait of a trial research subject. It does so by first reading in raw marker coordinate
information and forceplate data from a trial walk. It then processes it and cleans it, eliminating markers with
too much missing information (this percentage threshold can be tailored in mainConfig.txt). Afterwards, it then analyzes the 
marker coordinates and force values during gait and returns gait parameters such as step lengths and times, knee angles, 
gaitcycles, etc.

Note on the raw marker/force datafiles : this raw data must be obtained by you, as this code will be analyzing your specified gait 
trial data. The markers must be placed on the subject and these markers are read by cameras from your gait analyzing system.  -  - The ones used in our research lab are NEXUS (outputs .csv files) and D-FLOW (outputs .txt files), however we will be most likely be staying with D-FLOW / .txt raw datafiles due to a mismatch in camera frequencies between NEXUS and D-FLOW marker datafiles.

I don't consider this code to be completely done in it's current state, nor do I ever expect it to be in a be-all do-all state.
However, I believe that it's reached a reasonably useable state that it should be now runnable with relatively few hiccups. 
 - Of course there will always be bugs to fix and errors to run into, but as of now it (should) do what the program has been designed,and can be of some use to other researchers. 
 - Improvements are of course always welcome!

A short example list of things that could still be done (but there will always be code that can be improved if one looks hard
enough).

TO DO :
- developing the wiki!
- organize files into folders so that mainscript is easier to see
- make symmetryAnalysis.m more automatic - current state requires some manual manipulation (adding in actual parameters and string values in function)
  - possibly add another group into mainConfig.txt?
- make mainConfig.txt easier to manage
- make reading in values/variables from mainConfig.txt in the function readConfig.m in a more automatic fashion.
- making sure that different datafiles are still supported (as of now I have only checked that .txt files (default) work, but
  .csv files and combination files (should) also still work, but has not been tested yet 
    - note only .txt and .csv files work as of now - adding more supported filetypes could be done (readConfig.m)

Special thanks to Dr. Kyle B. Reed, Tyagi Ramakrishnan, and Dr. Ismet Handzic at the Rehabilitation Engineering and 
Electromagnetic Design Laboratory (REEDLab) at the University of South Florida.
