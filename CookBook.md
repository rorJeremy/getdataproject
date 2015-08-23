# Introduction

The `run_analysis.R` script
* Merges the training and the test sets to create one data set.
* Extracts/Fetches the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names.
* Creates a second, independent tidy dataset with an average of each variable
  for each each activity and each subject. This tidy data set is exported as a txt file.
  
# The run_analysis.R Script

The script is basically a sequence of functions that each tackle one of steps above. Run the entire script by using the following command/function in the command line of R:

***Run Entire Script***
```bash
> wash.data()
```

The script makes the assumption that the "plyr" library is installed already.

# Given Data Set 

The original data set that we start with is divided into a training set, and a test set. Each set is also divided into three files that contain the following:
* an activity label
* an identifier of the subject
* measurements from the accelerometer and gyroscope

# Getting and Cleaning Data

The first thing the run_analysis script does is merge the training and test sets.  All together, there are 10,299 instances where each instance contains 561 features. Once the merge is complete, the table contains 562 columns.

Next, we fetch the mean and standard deviation features. Out of 560 measurement features, we are able to extract 33 mean and 33 standard deviations, which gives us a data frame with 68 features.

Now, the activity labels are replaced with "descriptive activity names", which can be found in the "activity_labels.txt" file.

The last step we do is create a tidy data set with the average of each variable for each activity and each subject. 10299 instances are divided into 180 groups, and we average out 66 mean and standard deviation features for each group. We end up with a data table that has 180 rows and 66 columns. The tidy data set is exported to "UCI_HAR_tidy_dataset.txt". The first row is the header that has the names for each column.
