# This R script reads the sensor signal data from the UCI HAR Dataset, 
# merges the training and test data sets, and extracts the mean and standard deviation
# values for each measurement from the dataset. 
# Before running the script, place the UCI HAR Dataset directory along with all its files 
# and subdirectories in your working directory. 

# Install needed libraries
install.packages("plyr")
library(plyr)

# Read test set input files
features <- read.table("UCI HAR Dataset/features.txt", sep="")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = "")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "")
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="")

# Set column names
colnames(X_test) <- features[,2]
Y_test <- join(Y_test, activity_labels)
colnames(Y_test) <- c("Activity_ID", "Activity")
colnames(subject_test) <- "Subject"

# Bind test set tables
test <- cbind(subject_test, Y_test, X_test)

# Read training set input files
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "")
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="")

# Set column names
colnames(X_train) <- features[,2]
Y_train <- join(Y_train, activity_labels)
colnames(Y_train) <- c("Activity_ID", "Activity")
colnames(subject_train) <- "Subject"

# Bind training set tables
train <- cbind(subject_train, Y_train, X_train)

# Bind test and training set tables into one table
joined <- rbind(train, test)

# Find columns for mean and standard deviation
columns_mean <- grep("mean", colnames(joined))
columns_std <- grep("std", colnames(joined))
columns <- c(1:3, columns_mean, columns_std)
columns <- sort(columns)

# Create final data set
final <- joined[,columns]

# Write final data set to a file
write.table(final, "tidy_data.txt", row.names=FALSE)
