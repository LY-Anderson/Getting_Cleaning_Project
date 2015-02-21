# Code for Getting_Cleaning_Project
# Course project for Coursera Course
# Getting and Cleaning Data

# Set up and Housekeeping
setwd("~/Documents/Lisa Documents/Coursera_Data_Science/Getting_Cleaning_Project/Getting_Cleaning_Project")
library(dplyr)
library(reshape2)

# Get training and test data sets from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# downloaded files to my working directory
# get data into temp tables
testTemp <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
trainTemp <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)

# Merge training and test data sets
completeFeatureSet <- rbind(testTemp,trainTemp)

# Extract the mean and standard deviation for each measurement
# Determine which columns are required and name them
featureNames <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
meanCols <- grep("mean", featureNames$V2)
stdCols <- grep("std", featureNames$V2)
keepCols <- sort(c(meanCols,stdCols))

partialFeatureSet <- select(completeFeatureSet, keepCols)


# Use "descriptive activity names" to name the activities in the data set
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
testLabelsTemp <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
trainLabelsTemp <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
completeLabelsSet <- rbind(testLabelsTemp,trainLabelsTemp)
completeLabelsSet <- rename(completeLabelsSet, ActivityCode = V1)
completeLabelsSetii <- merge(completeLabelsSet, activityLabels, by.x="ActivityCode", by.y="V1", all=TRUE)
completeLabelsSetiii <- rename(completeLabelsSetii, Activity=V2)
Activity <- completeLabelsSetiii$Activity

partialFeatureSetii <- cbind(Activity, partialFeatureSet)

# test result
# table(partialFeatureSetii$Activity, useNA="ifany")

# Label the data set with descriptive variable names
keepRows <- as.data.frame(keepCols)
keepRows$oldColName <- paste("V",keepRows$keepCols, sep="")
keepRowsii <- merge(keepRows,featureNames, by.x="keepCols", by.y="V1", all=FALSE)

newNamesT <- as.character(keepRowsii$V2)
newNames <- c("Activity",newNamesT)

colnames(partialFeatureSetii) <- newNames

# Create a second, independent, tidy data set with the average of each variable
# for each activity and each subject
testSubjectsTemp <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
trainSubjectsTemp <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
completeSubjectsSet <- rbind(testSubjectsTemp,trainSubjectsTemp)
completeSubjectsSet <- rename(completeSubjectsSet, SubjectCode = V1)

partialFeatureSetiii <- cbind(completeSubjectsSet, partialFeatureSetii)

ind_data <- melt(partialFeatureSetiii, id=c("SubjectCode", "Activity"), newNamesT)
ind_dataii <- dcast(ind_data, SubjectCode + Activity ~ variable, mean)


# Upload a data set as a txt file created with write.table() using
# row.name=FALSE
write.table(ind_dataii, file="Tidy_Movement_Data.txt", row.name=FALSE)





