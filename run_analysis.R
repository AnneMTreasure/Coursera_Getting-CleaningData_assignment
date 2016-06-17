
# this is the R script file for the Coursera Data Science Specialisation course: Getting and Cleaning Data
# the CodeBook.md file gives detailed information on the data and variables
# this code does the following:
        # 1 Merges the training and the test sets to create one data set.
        # 2 Extracts only the measurements on the mean and standard deviation for each measurement.
        # 3 Uses descriptive activity names to name the activities in the data set
        # 4 Appropriately labels the data set with descriptive variable names.
        # 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


###################### Set wd   ######################
getwd()
setwd("/Users/anne/Documents/A_Daily_sync_work_home/DataScience/Coursera/DataScienceSpecialisation/Course3_Getting&CleaningData/Assignment")


##################### Download zipped file from the internet   ######################

if (!file.exists("data")) {
        dir.create("data")
}

fileUrl  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

library(downloader)
download(fileUrl, dest="./data/dataset.zip", mode="wb") 


##################### unzip the file
unzip("./data/dataset.zip", exdir="./data")



## 1 ######################## IMPORT AND MERGE FILES   ######################

library(read.table)


        ################### common files: import

features <- read.table("data/UCI HAR Dataset/features.txt", header = FALSE)
activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", header = FALSE)


        ################### test files: import

x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)


        ################### train files: import

# same features file as above
x_train <- read.table("data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)


        ################### test files: rename columns & merge
namesf = features$V2
colnames(x_test) = namesf

test <- cbind.data.frame(y_test, subject_test, x_test)

names(test)[1:2] <- c("ActivityLabels", "Subject")


        ################### train files: rename columns & merge
namesf = features$V2
colnames(x_train) = namesf

train <- cbind.data.frame(y_train, subject_train, x_train)

names(train)[1:2] <- c("ActivityLabels", "Subject")


        ################### merge test and train data sets

mergedData <- rbind(test, train)



## 2 ######################## DATA EXTRACTION   ######################

# Extract only the measurements on the mean and standard deviation for each measurement.
#mean(): Mean value
#std(): Standard deviation

ExtractData <- mergedData[, grep("mean[[:punct:]]|std[[:punct:]]", names(mergedData), value = TRUE)]  # uses selecting by name

# need to select columns 1 and 2 as well, just used cbind again:
Data <- cbind(mergedData[1:2], ExtractData)



## 3 ######################## NAME ACTIVITES IN THE DATA SET   ######################

#activity_labels
#V1                 V2
#1  1            WALKING
#2  2   WALKING_UPSTAIRS
#3  3 WALKING_DOWNSTAIRS
#4  4            SITTING
#5  5           STANDING
#6  6             LAYING

Data$ActivityLabels[Data$ActivityLabels == '1'] <- 'Walking'
Data$ActivityLabels[Data$ActivityLabels == '2'] <- 'Walking upstairs'
Data$ActivityLabels[Data$ActivityLabels == '3'] <- 'Walking downstairs'
Data$ActivityLabels[Data$ActivityLabels == '4'] <- 'Sitting'
Data$ActivityLabels[Data$ActivityLabels == '5'] <- 'Standing'
Data$ActivityLabels[Data$ActivityLabels == '6'] <- 'Laying'



## 4 ######################## LABEL VARIABLES APPROPRIATELY   ######################
# Appropriately labels the data set with descriptive variable names

#names(Data)

# replace the following:
# BodyBody with Body
# prefix 't' with time
# prefix 'f' with frequency
# Acc with Acceleration
# Gyro with Gyroscope
# Mag with Magnitude

names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) <- gsub("Acc", "Acceleration", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))

#names(Data)


## 5 ######################## PRODUCE TIDY DATA SET WITH AVERAGES   ######################
# From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

#class(Data$Subject)
#class(Data$TrainingLabel)
#Data$TrainingLabel <- as.numeric(Data$TrainingLabel)

TidyData <- aggregate(Data[,3:68], by = list(activity = Data$TrainingLabel, subject = Data$Subject), FUN = mean)
write.table(x = TidyData, file = "TidyData.txt", row.names = FALSE)




