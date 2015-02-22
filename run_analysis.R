# Code for Getting_Cleaning_Project
# Course project for Coursera Course
# Getting and Cleaning Data

# Setup and Housekeeping
setwd("~/Documents/Lisa Documents/Coursera_Data_Science/Getting_Cleaning_Project/Getting_Cleaning_Project")
library(dplyr)
library(reshape2)

# Get training and test data sets from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# downloaded files to my working directory
# get main data into temp tables
testTemp <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
trainTemp <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)

# get subject columns
testSubjectsTemp <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
testSubjectsTemp <- rename(testSubjectsTemp, Subject=V1)
trainSubjectsTemp <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
trainSubjectsTemp <- rename(trainSubjectsTemp, Subject=V1)

# get activity columns
testLabelsTemp <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
testLabelsTemp <- rename(testLabelsTemp, Activity=V1)
trainLabelsTemp <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
trainLabelsTemp <- rename(trainLabelsTemp, Activity=V1)

# put subject and activity columns into test and training dataframes
test_df <- cbind(testSubjectsTemp, testTemp)
train_df <- cbind(trainSubjectsTemp, trainTemp)

test_df_ii <- cbind(testLabelsTemp,test_df)
train_df_ii <- cbind(trainLabelsTemp, train_df)

# Merge training and test data sets
completeFeatureSet <- rbind(test_df_ii, train_df_ii)


# Extract the factors which include a mean or standard deviation
# Determine which columns are required
featureNames <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
meanCols <- grep("mean", featureNames$V2)
stdCols <- grep("std", featureNames$V2)
keepCols <- sort(c(meanCols,stdCols))
keepColsRev <- c(1,2,keepCols+2)

partialFeatureSet <- select(completeFeatureSet, keepColsRev)

# Use "descriptive activity names" to name the activities in the data set
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
activityLabels <- rename(activityLabels, ActivityCode=V1, ActivityName=V2)

partialFeatureSetii <- merge(activityLabels, partialFeatureSet, by.x="ActivityCode", by.y="Activity", all=TRUE)
partialFeatureSetii <- select(partialFeatureSetii, 2:82)

# Rename the column headings from "V1" to more meaningful names
keepRows <- as.data.frame(keepCols)
keepRows$oldColName <- paste("V",keepRows$keepCols, sep="")
keepRowsii <- merge(keepRows,featureNames, by.x="keepCols", by.y="V1", all=FALSE)

newNamesT <- as.character(keepRowsii$V2)
newNames <- c("Activity","Subject",newNamesT)

colnames(partialFeatureSetii) <- newNames



# Create a second, independent, tidy data set with the average of each variable
# for each activity and each subject
ind_data <- melt(partialFeatureSetii, id=c("Subject", "Activity"), newNamesT)
ind_dataii <- dcast(ind_data, Subject + Activity ~ variable, mean)


# Upload a data set as a txt file created with write.table() using
# row.name=FALSE
write.table(ind_dataii, file="Tidy_Movement_Data.txt", row.name=FALSE)





