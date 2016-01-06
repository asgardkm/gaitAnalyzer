# How to Use

---

There are only two files that you need to bother with for the code to work (hopefully, if everything runs without issue) : the mainConfig.txt and the mainScript.m. Both files are in the functions directory.


The mainConfig.txt file is where the user defines certain variables for his/her data and for the code. This values may need to be tweaked for each person, as not all the values in it can be applied universally (ex, string names in the data). For more information, see the mainConfig.md doc file under documentation.

The mainScript.m is the actual code. This is what the user will run. It is broken up into three segments : 
 - moduleRead : this portion of code will read in the data you decide to input, process it, and save it as a structure variable in the MATLAB environment. It will also determine which functions to run, based on which markers where found in the datafile given.
 - moduleAnalyze : this portion of code will use the structure variable outputted from moduleRead and will return gait parameter values for the datafile. Outputs from this section will appear under the "output" structure.
 - symmetryAnalysis : this portion of code will only run if specified under mainConfig.txt. This will run symmetry tests for five gait parameters (currently - more may be added in the future) : step length, stance time, swing time, doublestance time, and swing/stance ratios. Outputs will appear in the "symmetry" structure.
   - For more information about how the symmetry functions were used, see 'Evaluation of gait symmetry after stroke: A comparison of current methods and recommendations for standardization' (Patterson et. al., 2010, University of Toronto). 
