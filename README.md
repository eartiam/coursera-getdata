coursera-getdata
================

Coursera - Getting and Cleaning Data course assignment

Repository contents
-------------------

* README.md: this file
* download_data.R: an R script to download an unpack the assignment data
* run_analysis.R: an R script to process the assignment data and generate
                  the resulting tidy data file from it.
* tidy_data_set.txt: the resulting tidy data file.
* tidy_features.txt: descriptive feature names for the tidy data set
                     variables.
* CODEBOOK.md: the codebook for the generated tidy data set.

Note
----

> We have considered that the columns containing the the mean and
> standard deviation for the measurements are the ones explicitly
> containing the strings '-mean()' and '-std()' respectively,
> applied to the signals measured (see features_info.txt in the
> assignment data set). Other variables containing 'mean' in their
> names (such as 'meanFreq') are not considered (though they could
> be easily included by changing the selecting regular expression
> in step 4, below).


Description of the run_analysis.R script
----------------------------------------

The run_analysis.R script performs the operations requested in the
assignement of the 'Getting and Cleaning Data' Coursera course. It
assumes that the assignment data has been previously downloaded and
unpacked in the working directory.

The following helper functions are defined at the beginning of the script:

* concatString(...): accepts one or more strings and concatenates them,
                     returning a single string.

* makePath(...): accepts one or more strings and concatenates them using a
                 slash (/) as separator (the result is suitable for use as
                 a file/dir path).
* readVector(file): reads a single column file and returns its contents as
                    a vector
* readKeyVal(file): reads a two column file and returns its contents as
                    table with the first column named "key" and the second
                    column named "val".


The script starts by performing a series of sanity checks, verifying that
the assignment data (the directory "UCI HAR DataSet") exists in the
current working directory, and none of the output files ("tidy_data_set.txt"
and "tidy_features.txt") exists. If any of this conditions is not satisfied,
the script stops.

Then, the script processes the assignment data as requested,
following the indications in the assignment documentation:

1. The list of features is read from the "features.txt" file. The "val"
   column of the resulting table contains the names of the columns of the
   "train/X_train.txt" and "test/X_test.txt" data files (the train and test
   data sets, respectively).

2. The train and test data sets are read using the read.table function,
   using the "val" column of the features table as column names, so that
   the columns of the resulting tables have descriptive names (as requested
   in point 3 of the documentation). The strip.white argument eliminates the
   heading white spaces in some of the rows.

3. The train and test data sets are concatenated using the rbind function,
   which generates a new table adding the rows from the test data set at
   the end of the rows from the train data set.

4. The assignment asks to extract the values corresponding to mean and
   standard deviation. According to the documentation in the
   "features_info.txt" file, the feature names corresponding to the
   relevant columns contain either the string "-mean()"
   (optionally followed by a hyphen, followed by more characters) for
   the average values, or the string "-std()" (optionally followed by a
   hyphen, followed by more characters) for the standard deviation values.
   We use the grep function to obtain the indices of the features matching
   the desired regular expressions in meanCols and stdCols respectively,
   and then we combine them in a single vector, sorting it to maintain
   the order. We use the resulting index vector to extract the columns
   from the merged data set.

5. We obtain two vectors with the values representing the activities from
   the train data set (file "train/y_train.txt") and the test data set
   (file "test/y_test.txt"). The concatenation of these two vectors
   correspond to the activity values for the merged data set.

6. In order to obtain the descriptive strings for the activities, we 
   read the "activity_labels.txt" file into a table with "key" and "val"
   columns, and use the activity values vector from the previous step as
   and index to map the values into descriptive strings. 

7. We generate a vector with the subject identifiers by reading the
   "train/subject_train.txt" and "test/subject_test.txt" files for the
   train and test data sets respectively. As we did in step 5 for activities,
   we concatenate the resulting vectors to obtain the subject information
   for the merged data set.

8. We use the 'aggregate' function to obtain the mean value of each variable
   for each activity and subject. The first two columns of the resulting
   data set will have all possible combinations of activity and subject,
   with the rest of each row containing the average values of the selected
   columns for each activity-subject combination.


The data set obtained is eventually written using the write.table function.
Additionally, the full feature names corresponding to the tidy data set
columns are also written in a separate file.


