# Load required libaries
library(plyr)
library(reshape2)

# read the activity labels and column names to make the dataset more descriptive
activity_labels <- read.table(
  file='UCI HAR Dataset/activity_labels.txt',
  colClasses=c('numeric', 'character'))
feature_names <- read.table(
  file='UCI HAR Dataset/features.txt',
  colClasses=c('numeric', 'character'))

# read the test set and the corresponding activity labels
test <- read.table(
  file='UCI HAR Dataset/test/X_test.txt',
  header=F,
  colClasses=c(rep('numeric', 561)))
test_labels <- read.table(file='UCI HAR Dataset/test/y_test.txt', header=F)
test_subjects <- read.table(
  file='UCI HAR Dataset/test/subject_test.txt',
  header=F)
# combine the activity labels, subjects, and test data
labeled_test <- cbind(test_labels, test_subjects, test)

# read the training set and corresponding activity labels and subjects
train <- read.table(
  file='UCI HAR Dataset/train/X_train.txt',
  header=F,
  colClasses=c(rep('numeric', 561)))
train_labels <- read.table(file='UCI HAR Dataset/train/y_train.txt', header=F)
train_subjects <- read.table(
  file='UCI HAR Dataset/train/subject_train.txt',
  header=F)
# combine the activity labels, subjects, and training data
labeled_train <- cbind(train_labels, train_subjects, train)

# add the training and test datasets together into a single combined set
# (this is 1. from the assignment)
combined_test_train <- rbind(labeled_test, labeled_train)

# Set the names of the columns to be the names from features.txt
# (this is 4. from the assignment)
names(combined_test_train) <- c('activity', 'subject', feature_names[,2])

# find the column numbers for the mean and standard deviation by matching all
# columns that have the words 'std' or 'mean' in their name.
# (this is 2. from the assignment)
mean_and_std_cols <- sapply(
  colnames(combined_test_train), function(x) grep('std|mean', x))
mean_and_std_cols <- which(mean_and_std_cols == 1)

# filter the activity label, subject, and mean and standard deviation
# columns from dataset
mean_and_std_data <- combined_test_train[,c(1, 2, mean_and_std_cols)]

# turn the subjects into factors so they can be used as indexes later
mean_and_std_data$subject <- factor(mean_and_std_data$subject)

# Convert the activity column into a factor with a description
# (this is 3. from the assignment)
mean_and_std_data$activity <- factor(
    mean_and_std_data$activity,
    levels=activity_labels[,1],
    labels=activity_labels[,2])

# Melt the mean and standard deviation data into a suitable form to cast
melted_mean_and_stddev <- melt(
  mean_and_std_data,
  id.vars=c('subject', 'activity'),
  measure.vars=names(mean_and_std_data)[3:81])

# cast the data into a wide table first by subject, then activity, then
# take the mean of each variable (which becomes a named column)
final_wide_tidy_table <- dcast(
  melted_mean_and_stddev,
  subject + activity ~ variable,
  value.var='value',
  mean)

# write the table with the tidy data to a file called 'tidy-data.txt'
write.table(final_wide_tidy_table, 'tidy-data.txt', row.name=F)
