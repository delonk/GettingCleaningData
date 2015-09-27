### Getting And Cleaning Data Course Project Readme.md
### This document serves to describe the usage of the run_analysis.R script. 

The run_analysis.R script merges test and training data and creates a single large set of data.
The script then extracts the mean and standard deviation colums from the data set. 
The script also changes the activity column data to meaningul names, instead of numbers, i.e., instead of "1" you get "Walking".
It also applies the names of the columns. 
This large data set is not returned.

A new data set is then created as a text file, called tidy.txt
This file contains subject data, activity data and the mean for all the data in the row about a subject.

###Useage: 
source("run_analysis.R")
The script assumes that it is executed in the users working directory. This working directory contains the unzipped test and training data.

###Arguments
This scripts accepts no arguments.

###Output 
the script generates a single text file named "tidy.txt" in the working directory. 







