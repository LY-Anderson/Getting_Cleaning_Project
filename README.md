README file for:
Course project for "Getting and Cleaning Data"


Purpose of Code:
Aggregate some elements of the "Human Activity Recognition Using Smartphones Dataset"
(see the CodeBook for more details of the data source)

Steps:
1. Download the data from here into your working directory: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. Run code run_analysis.R.

Function of Code:
a. Join the training and test sets to obtain the full set.
- 'train/X_train.txt': Training set.
- 'test/X_test.txt': Test set.

b. Use the following files to identify the Subject and Activity for each row of data:
- 'train/y_train.txt': Training labels.
- 'test/y_test.txt': Test labels.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'features.txt': List of all features.

c. Select only the features which are either means or standard deviations.

d. Calculate the average of the selected features, aggregated by each unique combination of Subject and Activity.