library(dplyr)

#go to data sets directory
path_to_dataset <- 'UCI HAR Dataset/'

#
# 0. Initializations
#   a. read features variable names
#   b. read the training and test files
#

# 0.a. the features (variable) names
cat('Reading files ... ')
features <- read.table(file = paste(sep = "", path_to_dataset, 'features.txt'),
            col.names=c('feature_id', 'feature_name'))


# 0.b. read training and test data
subject_train <- read.table(file = paste(sep = "", path_to_dataset,
                  'train/subject_train.txt'), 
                  col.names = 'subject_id')

subject_test <- read.table(file = paste(sep = "", path_to_dataset,
                  'test/subject_test.txt'), 
                  col.names = 'subject_id')

X_train <- read.table(file = paste(sep = "", path_to_dataset,
                  'train/X_train.txt'),
                  col.names = features$feature_name,
                  check.names = FALSE)

X_test <- read.table(file = paste(sep = "", path_to_dataset,
                  'test/X_test.txt'),
                  col.names = features$feature_name,
                  check.names = FALSE)

y_train <- read.table(file = paste(sep = "", path_to_dataset,
                  'train/y_train.txt'),
                  col.names = 'activity_id')

y_test <- read.table(file = paste(sep = "", path_to_dataset,
                  'test/y_test.txt'),
                  col.names = 'activity_id')
cat('Done.')

##########################
## 1. Merge the datasets
##########################

cat('\n#1. Mergin data sets ... ')

# Merging training set files--> merging columns
training_set <- cbind(subject_train, y_train, X_train)

# Merging test set files--> merging columns
test_set <- cbind(subject_test, y_test, X_test)

# Merging the training set and the data set
data_set <- rbind(training_set, test_set)

cat('done.')

#################################################
## 2. Extract only mean and standard deviation
#################################################
cat('\n#2. Extracting only mean and std columns ... ')

# subset only features that contain the words "mean" or "std"
selected_names <- grepl('(mean|std)\\(\\)', names(data_set));
selected_names[1:2] <- TRUE

data_set <- data_set[,selected_names]

cat('done')

############################################################
## 3. Use descriptive activity names to name the activities
############################################################

cat('\n#3. Adding descriptive activity names ... ')
activities <- read.table(file = paste(sep = "", path_to_dataset,
                'activity_labels.txt'),
                col.names=c('activity_id', 'activity_name'))

data_set <- merge(data_set, activities, by = 'activity_id')

# remove activity_id
data_set$activity_id <- NULL

# moving the activity column to the 2nd position
data_set <- data_set[, c(1, ncol(data_set), 2:(ncol(data_set)-1))]
cat('done')


############################################################
## 4. Labels the data set with descriptive variable names.
############################################################
cat('\n#4. Labels the data set with descriptive variable names ... ')

# remove parentheses and hyphen
names(data_set) <- gsub('\\-|\\(\\)', '', names(data_set))

# make names Camel Case
names(data_set) <- gsub('mean', 'Mean', names(data_set))
names(data_set) <- gsub('std', 'Std', names(data_set))

cat('done')


###########################################
## 5. Create an independant tidy data set
###########################################
cat('\n#5. Create an independant tidy data set ... ')
tidy_data_set <-  aggregate(. ~ subject_id + activity_name, 
                            data = data_set, FUN = mean)
write.table(x = tidy_data_set, file = 'tidy_data_set.txt', row.names = FALSE)
cat('done')

