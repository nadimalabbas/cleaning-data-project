# loading dplyr package is required to use select() in step 2
# and group_by() and summarize() and %>% operator in step 5
library(dplyr)

# directory of SAMSUNG data
data_dir = file.path("data", "UCI HAR Dataset")
# directories of train and test data
data_train_dir <- file.path(data_dir, "train")
data_test_dir <- file.path(data_dir, "test")

# path of features, labels, and data files
features_path <- file.path(data_dir, "features.txt")
activity_labels_path <- file.path(data_dir, "activity_labels.txt")
data_train_path <- file.path(data_train_dir, "X_train.txt")
data_test_path <- file.path(data_test_dir, "X_test.txt")
activity_train_path <- file.path(data_train_dir, "y_train.txt")
activity_test_path <- file.path(data_test_dir, "y_test.txt")
subject_train_path <- file.path(data_train_dir, "subject_train.txt")
subject_test_path <- file.path(data_test_dir, "subject_test.txt")

## Step 1: Merge training and test sets in one data set.
data_train <- read.table(data_train_path)
data_test <- read.table(data_test_path)
data_all <- rbind(data_train, data_test)

## Step 2: Extract the mean and std for each measurement.
features <- read.table(features_path)
meanAndStdFeatures <- grep("(mean|std)\\(\\)", features$V2)
data_mean_std <- select(data_all, all_of(meanAndStdFeatures))

## Step 3: Add descriptive activity names to the data set.
activity_train <- read.table(activity_train_path)
activity_test <- read.table(activity_test_path)
activity_all <- rbind(activity_train, activity_test)
activity_labels <- read.table(activity_labels_path)
activity_labeled <- inner_join(activity_all, activity_labels)
activity_labeled$V1 <- NULL
data_activity <- cbind(data_mean_std, activity_labeled)

## Step 4: Label the data set with descriptive variable names.
col_labels <- merge(meanAndStdFeatures, features, by.x = "x", by.y = "V1")
names(data_activity) <- c(col_labels$V2, "activity")

# add the subject to the data set to make step 5 easier
subject_train <- read.table(subject_train_path)
subject_test <- read.table(subject_test_path)
subject_all <- rbind(subject_train, subject_test)
names(subject_all) <- "subject"
data_act_subj <- cbind(data_activity, subject_all)

## Step 5: Create the new tidy data set by summarizing previous data.
new_data <- data_act_subj %>%
  group_by(activity, subject) %>%
  summarize(across(everything(), mean))
# summarize(across(everything(), func)) is the same as summarize_all(func)
# which was superseded by it

write.table(new_data, "data/tidy_averages.txt", row.names = FALSE)
