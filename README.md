# Summarizing SAMSUNG data

-   This repo is a course project for the [Getting and Cleaning Data](https://www.coursera.org/learn/data-cleaning/home/welcome) course on [coursera](https://www.coursera.org/).
-   In order for the R script to work, [SAMSUNG sensor data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) should be in the working directory of the script inside a directory named "data".
-   The R script *run_analysis.R* cleans up original data and creates a new data set that is based on the original.
-   The newly created data is described and explained in the code book *CodeBook.md*.

## Cleaning up

As per the instructions of the course project, cleaning up the original SAMSUNG data is performed in 4 steps.

#### Step 1: Merging training and test sets in one data set.

-   Since training and test sets both have the same structure and variables, merging them in one data set is easily done using `rbind()`.

#### Step 2: Extracting the mean and std for each measurement.

-   This is done by first identifying which variables (columns) in the data set are **mean** or **std** measurements.
-   *feature.txt* file is searched for features that contain either **mean** or **std** followed by parenthesis **()** using `grep()`, to get a vector of the indices of all these features.
-   Finally, the resulting vector is used as an argument to `select()` after wrapping it with `all_of()`, because using an external vector in selections was deprecated in tidyselect 1.1.0.

#### Step 3: Add descriptive activity names to the data set.

-   Activity data for training and test sets are merged the same as in Step 1 (using `rbind()`) into 1 data set.
-   Then this data set is labeled with its corresponding descriptive names by joining it with the data from *activity_labels.txt*.
-   The function `inner_join()` was chosen for this instead of `merge()` because it keeps the original row order of the first data frame.
-   After that, the activity_id column (V1) is removed because it is not needed when there is descriptive names for each activity id.
-   Finally, the activity column is added to the data frame from step 2 using `cbind()`.

#### Step 4: Label the data set with descriptive variable names.

-   The vector `meanAndStdFeatures` that was defined in step 2, storing the columns used in the data frame is merged with the `features` table (which contains the names of all features), in order to get the names of the columns (variables) of the data frame.
-   These names are then assigned to the column names of the data frame (`names(data_activity)`).

##### Extra step: Add subject data to the original data frame.

-   This will make it easier to summarize the data later.
-   It is done by merging training and test subject sets together using `rbind()` and naming the column "subject".
-   Then adding this column to the data frame using `cbind()`.

## New data

-   New tidy data set that contains the average of each variable for each activity and each subject is created.
-   This is done in step 5 of the R script by:

1.  Grouping the data frame from previous step by activity and subject using `group_by()`.
2.  Piping the resulting tibble (data frame) to `summarize()` to show the `mean()` of all measurements (`across(everything())`).
3.  Writing the data from `summarize()` to a new text file using `write.table()`.
