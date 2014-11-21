#
# Coursera: "Getting and Cleaning Data"
# Assignment 1 - Preparation
# Author: Ernest Artiaga
#

# Run with:
#   R --vanilla --slave < download_data.R

#
# PREPARATION
# Download and unpack the data files for the assignment in the current
# directory, if they do not exist yet.
#

# Source URL:
remoteUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Downloaded file
localFile <- "getdata-projectfiles-UCI_HAR_Dataset.zip"

# Unpacked directory name
expectedDir <- "UCI HAR Dataset"


# Check if target directory already exists
if (file.exists(expectedDir)) {
	print(paste(c("target directory already exists: ", expectedDir),
                collapse = ""))
    quit("no")
}

# Download zip file if not present
if (!file.exists(localFile)) {
	print(paste(c("downloading from source URL: ", remoteUrl), collapse = ""))
	download.file(url = remoteUrl, localFile, method="curl")
}

# Quit if the zip file still does not exist
if (!file.exists(localFile)) {
    print(paste(c("could not download file: ", localFile), collapse = ""))
    quit("no")
}
    
# Unpack the zip file
unzip(localFile)

# Check if the target directory exists
if (!file.exists(expectedDir)) {
    print(paste(c("failed to retrieve target directory: ", expectedDir),
                collapse = ""))
    quit("no")
}

print("ready")

