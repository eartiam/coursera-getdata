#
# Coursera: "Getting and Cleaning Data"
# Assignment 1
# Author: Ernest Artiaga
#

# Run with:
#    R --vanilla --slave < run_analysis.R

#
# UTILITIES
#


# Utility function: concatString
# Concatenate strings (useful for printing messages)
# Args: the strings to be concatenated
concatString <- function(...) {
    paste(c(...), collapse = "")
}

# Utility function: makePath
# Concatenate directory and file names to form a path
# Args: the strings containing the path components
makePath <- function(...) {
	paste(c(...), collapse = "/")
}

# Utility function: readVector
# Read single-column file into a vector
# Args: file: the file to read from
#       class: force the class of the values (default: autodetect)
readVector <- function(file, class = NA) {
	read.table(file, colClasses = class)[,1]
}

# Utility function: readKeyVal
# Read two-column file containing a key and a descriptive value
# Args: file: the file to read from
#       sep: the separator
readKeyVal <- function(file, sep = "") {
	read.table(file, sep = sep, col.names = c("key", "val"))
}

# The following directory is expected in the current working directory and
# should contain the dataset for the assignment.
# You may use the download_data.R script to download and unpack the necessary
# data.

dataDir <- "UCI HAR Dataset"

if (!file.exists(dataDir)) {
	print(concatString("missing data directory: ", dataDir))
    print("please, download and unpack the data and try again")
    quit("no")
}

# The following file is the name of the resulting data set.
# Refuse to continue if the file already exists.
tidyFile <- "tidy_data_set.txt"
tidyFeaturesFile <- "tidy_features.txt"
if (file.exists(tidyFile)) {
	print(concatString("existing result file: ", tidyFile))
    print("please, remove it if you want to generate it again")
    quit ("no")
}
if (file.exists(tidyFeaturesFile)) {
	print(concatString("existing labels file: ", tidyFeaturesFile))
    print("please, remove it if you want to generate it again")
    quit ("no")
}

#
# ASSIGNMENT
#

#
# Step 1
# Merge the training and the test sets
#


# Get feature list
features <- readKeyVal(makePath(dataDir, "features.txt"))

# Read train data
# Using feature names as column names, so columns have descriptive names
trainData <- read.table(makePath(dataDir, "train/X_train.txt"),
                        col.names = features[["val"]], strip.white = TRUE)


# Read test data
# Using feature names as column names, so columns have descriptive names
testData <- read.table(makePath(dataDir, "test/X_test.txt"),
                        col.names = features[["val"]], strip.white = TRUE)

# Merge data sets, appending rows from test data after train data
mergedData <- rbind(trainData, testData)


#
# Step 2
# Extract the measurements on the mean and standard deviation
#
# The following code uses the fact that column names containing mean and
# standard deviation for each measurement contain the string '-mean()' and
# '-std()' respectively (the hyphen - at the beginning is important to avoid
# names like 'freqmean'). This information is extracted from the files
# 'features_info.txt' and 'features.txt' in the data set.

# Column indexes containing mean values: '.*-mean()' and '.*-mean()-{X,Y,Z}'
meanCols <- grep('-mean\\(\\)(-|$)', features[["val"]])

# Column indexes containing std values: '.*-std()' and '.*-std()-{X,Y,Z}'
stdCols <- grep('-std\\(\\)(-|$)', features[["val"]])

# Extract the interesting columns, by merging the relevant column indexes
# and extracting them from the original data frame.
relevantCols <- sort(c(meanCols, stdCols, recursive = TRUE))
filteredData <- mergedData[,relevantCols]


#
# Step 3
# Use descriptive activity names to name the activities in the data set
#


# Read activity label keys corresponding to train and test data sets
trainLabels <- readVector(makePath(dataDir, "train/y_train.txt"))
testLabels <- readVector(makePath(dataDir, "test/y_test.txt"))

# Concatenate activity indexes from train and test sets
allActivities <- c(trainLabels, testLabels, recursive = TRUE)

# Read descriptive activity names from the activity_labels file
activities <- readKeyVal(makePath(dataDir, "activity_labels.txt"))

# prepare a new vector with descriptive names
descriptiveActivities <- activities[allActivities, "val"]


#
# Step 4
# label the data set with descriptive variable names
#

# NOTE: alredy done by using the col.names parameter in the read.table
# commands in STEP 1 (col.names = features[["val"]].

#
# Step 5
# Create a data set with the average of each variable for each activity and
# subject
#

# retrieve subject identifiers from train and test data sets
trainSubjects <- readVector(makePath(dataDir, "train/subject_train.txt"))
testSubjects <- readVector(makePath(dataDir, "test/subject_test.txt"))

# concatenate subject information and add new subject column to data set
allSubjects <- c(trainSubjects, testSubjects, recursive = TRUE)

# calculate aggregated mean values, grouped by subject and activity

tidy <- aggregate(filteredData,
                  by = list (activity = descriptiveActivities,
                             subject = allSubjects),
                  FUN = mean)


#
# Write data to a file
#

write.table(tidy, file = tidyFile, row.names = FALSE)

#
# Reconstruct feature labels for tidy file (note that the aggregate function
# adds activity and subject as the first two columns)
#

tidyFeatures <- c("activity", "subject",
                  as.character(features[relevantCols, "val"]),
                  recursive = TRUE)
write.table(tidyFeatures, file = tidyFeaturesFile,
            row.names = FALSE, col.names = FALSE, quote = FALSE)


