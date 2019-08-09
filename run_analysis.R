getwd()

# Loading Packages
library(dplyr)

# Read data
setwd('C:/Users/schat/OneDrive/바탕 화면/coursera/data/final_assign')
fileurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileurl,'final_assign.zip')
unzip('final_assign.zip')

# Assign Data
setwd('C:/Users/schat/OneDrive/바탕 화면/coursera/data/final_assign/UCI HAR Dataset')
feature <- read.table('features.txt',col.names = c('n','feature'))
activities <- read.table('activity_labels.txt',col.names = c('code','activity'))
subject_test <- read.table('test/subject_test.txt',col.names = 'subject')
X_test <- read.table('test/X_test.txt',col.names = feature$feature)
Y_test <- read.table('test/y_test.txt', col.names = 'code')
subject_train <- read.table('train/subject_train.txt', col.names = 'subject')
X_train <- read.table('train/X_train.txt', col.names = feature$feature)
Y_train <- read.table('train/y_train.txt', col.names = 'code')

# 1. Merges the training and the test sets to create one data set.
X_merge <- rbind(X_train,X_test)
Y_merge <- rbind(Y_train, Y_test)
subject_merge <- rbind(subject_train,subject_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
colnames(X_merge)[1:50]
tidy_data <- X_merge %>%
  select(contains('.mean.'),contains('.std.'))
colnames(tidy_data)

dim(tidy_data)

# 3. Uses descriptive activity names to name the activities in the data set.
Y_merge[,1] <- activities[Y_merge[,1],2]
tidy_data <- cbind(tidy_data,Y_merge,subject_merge)

# 4. Appropriately labels the data set with descriptive variable names.
colnames(tidy_data)
names(tidy_data) <- gsub('Acc','Acceleration', names(tidy_data))
names(tidy_data) <- gsub('GyroJerk','AngularAcceleration', names(tidy_data))
names(tidy_data) <- gsub('Gyro','AngularSpeed', names(tidy_data))
names(tidy_data) <- gsub('Mag','Magnitude', names(tidy_data))
names(tidy_data) <- gsub('^t','TimeDomain', names(tidy_data))
names(tidy_data) <- gsub('^f','FrequencyDomain', names(tidy_data))
names(tidy_data) <- gsub('mean','Mean', names(tidy_data))
names(tidy_data) <- gsub('std','StandardDeviation', names(tidy_data))
names(tidy_data) <- gsub('^t','TimeDomain', names(tidy_data))
names(tidy_data) <- gsub('code','Activity', names(tidy_data))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Final_data <- aggregate(. ~subject + Activity, tidy_data, mean)
Final_data <- Final_data %>%
  arrange(subject, Activity)

write.table(Final_data, file = 'Tidy_Data.txt', row.names = F)
getwd()

# END
