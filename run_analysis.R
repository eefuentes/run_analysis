# run_analysis.R

# This script is part of the "Getting and Cleaning Data" course project.
# It does the following:
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Labels the data set with descriptive variable names. 
#   5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)

run_analysis <- function(){
        # Load activity labels and features (data assumed to be in "dataset" folder)
        activitylabels <- read.table("dataset/activity_labels.txt", header=FALSE)
        colnames(activitylabels) <- c("activity", "label")
        features <- read.table("dataset/features.txt", header=FALSE)
        colnames(features) <- c("id", "feature")

        # Load test datasets (data assumed to be in "dataset" folder)
        xtest <- read.table("dataset/test/X_test.txt", header=FALSE)
        colnames(xtest) <- make.names(features$feature, unique=TRUE)
        ytest <- read.table("dataset/test/y_test.txt", header=FALSE)
        colnames(ytest) <- "activity"
        subjecttest <- read.table("dataset/test/subject_test.txt", header=FALSE)
        colnames(subjecttest) <- "subject"
        
        # Column bind subject and activity to xtest dataset
        xtest <- cbind(subjecttest, ytest, xtest)

        # Load train datasets (data assumed to be in "dataset" folder)
        xtrain <- read.table("dataset/train/X_train.txt", header=FALSE)
        colnames(xtrain) <- make.names(features$feature, unique=TRUE)
        ytrain <- read.table("dataset/train/y_train.txt", header=FALSE)
        colnames(ytrain) <- "activity"
        subjecttrain <- read.table("dataset/train/subject_train.txt", header=FALSE)
        colnames(subjecttrain) <- "subject"

        # Column bind subject and activity to xtrain dataset
        xtrain <- cbind(subjecttrain, ytrain, xtrain)
        
        # Row bind (merge) test and train data
        mergeddata <- rbind(xtest, xtrain)

        # Convert activities to descriptive activity names (labels)
        mergeddata$activity <- factor(mergeddata$activity, levels=activitylabels$activity, label=activitylabels$label)
        
        # Select only mean and standard deviation fields
        msData <- select(mergeddata, subject, activity, contains("mean"), contains("std"))
        
        # New tidy dataset with field means by subject and activity
        # Goes thru msData by activity and subject to calculate the mean of each variable
        tidyDS <- data.frame(matrix(NA, nrow=0, ncol=ncol(msData)))
        colnames(tidyDS) <- make.names(names(msData), unique=TRUE)
        linenumber=1
        for(act in activitylabels$label) {
                for(subj in 1:30) {
                        tempDF <- filter(msData, activity==act & subject==subj)
                        meanresult <- lapply(tempDF, mean)
                        tidyDS[linenumber,] <- lapply(tempDF, mean)
                        tidyDS[linenumber,1] <- subj
                        tidyDS[linenumber,2] <- act
                        linenumber <- linenumber + 1
                }
        }
        
        # Write tidy dataset to tidydata.txt
        write.table(x=tidyDS, file="tidydata.txt", row.names=FALSE)
}
