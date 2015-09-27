##  This script aims to fulfil all requirements as set out in the Course Project for "Getting and Cleaning Data".
##  The script is named "run_analysis.R". It accepts no arugments and assumes that the data directory
##  "UCI HAR Dataset" is unzipped and  in the working directory where the script is to be executed.
##  The script reads in various files in this data directory and creates 

## Read in features which will be used as a column header
features <- read.csv("./UCI HAR Dataset/features.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)

#features.txt is read in with two colums. We're interested only in column 2.
features.vertical <- features[2] 

#initial the horizatal list of features.
features.horizontal <- NULL

#this for loop will transform the vertical colum to a horizontal vector
# to be used as colum names. 
#The column names are determined from "features.txt" file.

for (i in 1 : nrow(features.vertical))
{
       features.horizontal[i] <- features.vertical$V2[i] 
}

#Read in both test and train data sets.
test.data <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
train.data <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)

#Apply the column names to the train and test sets.
colnames(test.data) <- features.horizontal
colnames(train.data) <- features.horizontal

#Read in subject data for both train and test data.
test.subject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
train.subject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Apply the column name to the subject data.
colnames(test.subject) <- "Subject"
colnames(train.subject) <- "Subject"

#Read in data about the Activity, i.e, walking, walking upstairs, etc.
test.labels <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
train.labels <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

#Apply the names to the column data
colnames(test.labels) <- "Activities"
colnames(train.labels) <- "Activities"

#Extract all columns with the word "mean" for test data.
test.means.cols <- grep("mean", names(test.data), value = TRUE)
test.means <- test.data[, test.means.cols]

#Extract all columns with the word "mean" for train data.
train.means.cols <- grep("mean", names(train.data), value = TRUE)
train.means <- train.data[, train.means.cols]

#Extract all columns with the word "Mean" (upper case M) for both test.
test.Means.cols <- grep("Mean", names(test.data), value = TRUE)
test.Means <- test.data[, test.Means.cols]

#Extract all columns with the word "Mean" (upper case M) for training data.
train.Means.cols <- grep("Mean", names(train.data), value = TRUE)
train.Means <- train.data[, train.Means.cols]

#Extract all columns with the letters std for test data.
test.sd.cols <- grep("std", names(test.data), value = TRUE)
test.sd <- test.data[, test.sd.cols]

#Extract all columns with the letters std for train data.
train.sd.cols <- grep("std", names(train.data), value = TRUE)
train.sd <- train.data[, train.sd.cols]

#combine colum data for test data
test.combined <- cbind(test.subject, test.labels, test.means,test.Means,test.sd)

#combine colum data for train data
train.combined <- cbind(train.subject, train.labels, train.means,train.Means,train.sd)

#Combine two data sets using rbind to create one large dataset.
combined <- rbind(test.combined, train.combined)

# This for loop converts values 1.. 6 into "meaningful" names. I've used the "activity_lables" 
# file guidance. 

for (i in 1 : nrow(combined))
{
       if ( combined$Activities[i] == 1)
              combined$Activities[i] <- "Walking"
       else if ( combined$Activities[i] == 2)
              combined$Activities[i] <- "Walking Upstairs"
       else if ( combined$Activities[i] == 3)
              combined$Activities[i] <- "Walking Downstairs"
       else if ( combined$Activities[i] == 4)
              combined$Activities[i] <- "Sitting"
       else if ( combined$Activities[i] == 5)
              combined$Activities[i] <- "Standing"
       else if ( combined$Activities[i] == 6)
              combined$Activities[i] <- "Laying"


}

#At this point, the combined data set is created and is called "combined" 

#Combine the columns for caluclating the means - all columns containing "mean", "Mean" or "std" to be used in the calulation below.
test.clean.means <- cbind(test.means,test.Means,test.sd)

#Combine the columns for caluclating the means - all columns containing "mean", "Mean" or "std" to be used in the calulation below.
train.clean.means <- cbind(train.means,train.Means,train.sd)

#Create on large data set of means.
combined.clean.means <- rbind(test.clean.means, train.clean.means)

#Calulcate means for each row. This provides the average of each variable for each activity and each subject
combined.final.means <- rowMeans(combined.clean.means)

#This for loop transforms horizontal data into a column.
final.means <- NULL
for (i in 1 : length(combined.final.means))
{
		final.means <- rbind(final.means, combined.final.means[i]) 
}

#Combine Subject and Activity and the new mean per subject. 

combine.clean <- cbind(combined[,1:2], final.means)
colnames(combine.clean) <- c("Subject", "Activity","Final Mean")

#Write data using write.table and row.names = FALSE.
write.table(combine.clean, "tidy.txt", row.names = FALSE)

