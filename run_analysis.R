library(plyr)

merge.datasets = function() {
    # First we read the data
    message("Reading the X_train.txt file!")
    training.x <- read.table("UCI HAR Dataset/train/X_train.txt")
    message("Reading the y_train.txt file!")
    training.y <- read.table("UCI HAR Dataset/train/y_train.txt")
    message("Reading the subject_train.txt file!")
    training.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
    message("Reading the X_test.txt file!")
    test.x <- read.table("UCI HAR Dataset/test/X_test.txt")
    message("Reading the y_test.txt file!")
    test.y <- read.table("UCI HAR Dataset/test/y_test.txt")
    message("Reading the subject_test.txt file!")
    test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

    message("Merging the data sets!")
    merged.x <- rbind(training.x, test.x)
    merged.y <- rbind(training.y, test.y)
    merged.subject <- rbind(training.subject, test.subject)

    # Creates and returns a list with the following dataframes: X, y, and subject
    list(x=merged.x, y=merged.y, subject=merged.subject)
}

fetch.mean.and.std = function(df) {
    # Only get the mean and standard deviation for each measurement.

    message("Reading from the features.txt file!")
    features <- read.table("UCI HAR Dataset/features.txt")
    # Find the mean and std columns
    mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
    std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
    
    message("Fetching the mean and std from the data!")
    edf <- df[, (mean.col | std.col)]
    colnames(edf) <- features[(mean.col | std.col), 2]
    edf
}

name.activities = function(df) {
    # Using descriptive activity names to name the activities in the dataset
    colnames(df) <- "activity"

    df$activity[df$activity == 1] = "WALKING"
    df$activity[df$activity == 2] = "WALKING_UPSTAIRS"
    df$activity[df$activity == 3] = "WALKING_DOWNSTAIRS"
    df$activity[df$activity == 4] = "SITTING"
    df$activity[df$activity == 5] = "STANDING"
    df$activity[df$activity == 6] = "LAYING"

    df
}

bind.data <- function(x, y, subjects) {
    # Bring together the mean and std values (x), the activities (y), and the subjects into a single data frame.
    cbind(x, y, subjects)
}

create.tidy.dataset = function(df) {
    # This function creates an independent tidy dataset with the average of each variable for each activity and each subject.
    tidy <- ddply(df, .(subject, activity), function(x) colMeans(x[,1:60]))
    tidy
}

wash.data = function() {
    # First, merge the data sets
    dataMerged <- merge.datasets()

    # Fetch the mean and standard deviation for each measurement
    xColumn <- fetch.mean.and.std(dataMerged$x)

    # Name the activities
    yColumn <- name.activities(dataMerged$y)

    # Use descriptive column name for the subjects
    colnames(dataMerged$subject) <- c("subject")

    # Combine all the data frames
    combined <- bind.data(xColumn, yColumn, dataMerged$subject)

    # Create a tidy dataset
    tidyData <- create.tidy.dataset(combined)
    
    # Write tidy data as a txt file
    message("Writing the tidy data into a txt file!")
    write.table(tidyData, "UCI_HAR_tidy_dataset.txt", row.names=FALSE)
}