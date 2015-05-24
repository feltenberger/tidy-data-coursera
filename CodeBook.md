# Coursera Getting and Cleaning Data Course Project

This data transformation requires the libraries `plyr` and `reshape2`. They are automatically loaded in `run_analysis.R`, but if they aren't installed in your R environment the source will not operate properly. 

The following operations and transformations were performed on the raw UCI HAR Dataset:

1. Load the required libaries (`plyr` and `reshape2`).
2. Load the activity labels (`activity_labels.txt`) and feature names (`features.txt`) for use in annotating the data later.
3. Read the test data (`X_test.txt`). Don't read headers and coerce the columns to be numeric. Here we also load the labels (`y_test.txt`) and subjects (`subject_test.txt`) for the test data and bind the three datasets together using `cbind`.
4. Perform the same operations that we performed on the test data to the training data, using the corresponding training data: `X_train.txt`, `y_train.txt`, and `subject_train.txt` respectively.
5. Combine the test and train data into a single data table using `rbind`. This is number 1 from the programming assignment. The test data rows are first, training second, though this is unimportant with regard to the exercise. The result is stored in `combined_test_train`.
6. Apply names to the columns: `activity`, `subject`, and all the feature names specified in `features.txt` (for example `tBodyAcc-mean()-X`, `tBodyAcc-std()-X`, etc.). The order of the columns is the same as the order read in from `features.txt`, so we don't need to do anything fancy to index them: simply apply using `names()`. This is number 4 from the assignment (doing them out of order makes more sense, because number 2 requires knowing the column names).
7. Find the column numbers that match the terms `std` and `mean` by filtering them through `grep` and checking which ones are `1` (i.e. which ones match). These are then combined into the `mean_and_std_data` variable by taking all rows of `combined_test_train` and columns 1 (`activity`), 2 (`subject`) and the ones that had names matching `std` or `mean`. This is number 2 from the assignment.
8. Make the activity human-readable with descriptions. An easy way to do this is to make the activity a factor using the descriptions from `activity_labels.txt`, which is done using the `factor` function and re-assigning it to `mean_and_std_data$activity`. This is number 3 from the assignment.
9. Now we're ready to produce the final dataset, number 5 from the assignment. This takes a few steps.
* First, `melt` the data such that we keep the subject and activity indexed as `id.vars` and use every other column as `measure.vars` so we have a long tidy table of data that is _not yet summarized_. This is stored in `melted_mean_and_stddev`.
* Next, we want to cast (actually, `dcast`) the melted data (`melted_mean_and_stddev`) first by subject, then activity, aggregating by `variable` (the variable column produced by `melt`). The `value.var` that gets aggregated is `value` (produced by `melt`). This is all passed through `mean` since the assignment asks for the mean of all activities by subject and variable.
* The result of the cast is a 'wide' data set with the first column being the subject, the second the activity, and the remainder of the columns (79 of them!) being the mean of each measurement for the given `subject-activity` combination. The measurements included are only those that are for standard deviations or means. Note that the description of what each column means is available in the UCI HAR Dataset file `features_info.txt`.
* Finally, write out the table with no row names to `tidy-data.txt`.
