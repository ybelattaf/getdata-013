# "Getting and cleaning data" project CodeBook
This code book describes data, variables and transformations performed in order to get the tidy data.

## About data
This project uses the "Human Activity Recognition Using Smartphones" data set.

You can find information about the data source in : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The oroginal data is available in : http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip

## Variables

* The following variables contain the data loaded from the different files.

 ** *features* : Contains the features names
 ** *subject_train* : data frame containing the training subjects IDs
 ** *subject_test*  : data frame containing the test subjects IDs
 ** *X_train* : data frame containing the training sensors observations
 ** *X_test* : data frame containing the test sensors observations
 ** *y_train* : data frame containing the training activity observations
 ** *y_test* : data frame containing the test activity observations
 ** *activities* : data frames that contains the activity IDs and their corresponding names

* The above variables are used as temporary variables in oder to build the tidy data set :

 ** *training_set* : contains the training set (constructed by mergin all training data)
 ** *test_set* : contains the test set (constructed by mergin all test data)
 ** *data_set* : contains the the whole data set and used as a working (temporary) variable
 ** *selected_names* : the feature names that contain the words 'mean' or 'std' + the subject_id and activity_id

* The variable *tidy_data_set* contains the resulting tidy data set.



## Transformations
0. Start by reading the files into the variables. Note that we've specified column names when reading the files.

1. The first step consists on merging the files in order to get a unique data set. We've used cbind to construct the whole test set and the hole trainig set. We used rbind to merge the training and the test sets in order to get the unique data set "data_set"

2. Extract only the columns that are mean or standard deviation. For that porpose we used the "grepl" function to select the column names that contain "mean" or "std". With the selected column names we subseted the data frame. It now conctains only the columns tha mean at correspond to "mean" or "std".

3. To replace activity codes with the activity labels, we've used the "merge" function (dpryl) that joined the "data_set" and the "activities" variables based in activity_id. We've got then a new column "activity_name". We also removed the activity_id column and moved the activity_name.

4. A transformation is done on column names in order to make them mode understandable. We used the gsub function for that prurpose.

5. The target tidy data set (average of each measurement for eache subject and each activity) set has been computed using the aggregate function.


