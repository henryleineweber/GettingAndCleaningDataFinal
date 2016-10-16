# Set working directory, download data, and extract files to directory
setwd("./RunAnalysis")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getdata_dataset.zip")
unzip("getdata_dataset.zip")

# Following will merge all data files in the extracted folder into a single data set

	## Read and assign data names
	features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
	activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
	s_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
	x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
	y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE)
	s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
	x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
	y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE)
	
	## Set column names
	colnames(activity) <- c("activityID","activityType")
	colnames(s_train) <- "subjectID"
	colnames(x_train) <- features[,2]
	colnames(y_train) <- "activityID"
	colnames(s_test) <- "subjectID"
	colnames(x_test) <- features[,2]
	colnames(y_test) <- "activityID"
	
	## Merge all data into a training dataset and a test dataset
	trainingdata <- cbind(s_train, x_train, y_train)
	testdata <- cbind(s_test, x_test, y_test)
	
	## Merge training and test data and get vector of new column headers
	combined_data <- rbind(trainingdata, testdata)
	headers <- colnames(combined_data)
	
# Extracts only the measurements on the mean and standard deviation for each measurement
	extract <- (grepl("activity..", headers) | grepl("subject..", headers) | grepl("-mean..", headers) & !grepl("-meanFreq..", headers) & !grepl("mean..-", headers) | grepl("-std..", headers) & !grepl("-std()..-", headers));
	working_data <- combined_data[extract == TRUE]
	
	## Add activity descriptions
	working_data <- merge(working_data, activity, by="activityID", all.x = TRUE)
	headers <- colnames(working_data)
	
# Clean up column names in new data frame
for (i in 1:length(headers)) 
{
  headers[i] = gsub("\\()","",headers[i])
  headers[i] = gsub("-std$","StdDev",headers[i])
  headers[i] = gsub("-mean","Mean",headers[i])
  headers[i] = gsub("^(t)","time",headers[i])
  headers[i] = gsub("^(f)","freq",headers[i])
  headers[i] = gsub("([Gg]ravity)","Gravity",headers[i])
  headers[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",headers[i])
  headers[i] = gsub("[Gg]yro","Gyro",headers[i])
  headers[i] = gsub("AccMag","AccMagnitude",headers[i])
  headers[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",headers[i])
  headers[i] = gsub("JerkMag","JerkMagnitude",headers[i])
  headers[i] = gsub("GyroMag","GyroMagnitude",headers[i])
}
colnames(working_data) = headers

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
	
	## Remove Activity Type column to avoid NA values when getting mean
	working_data_noAT <- working_data[, names(working_data) != "activityType"]

	## Create tidy data set
	tidy_data <- aggregate(working_data_noAT, by=list(working_data_noAT$activityID, working_data_noAT$subjectID), FUN=mean)

	## Merge Activity Type column back into dataframe
	tidy_data <- merge(tidy_data, activity, by="activityID", all.x = TRUE)
	
# Export tidy data to working directory
write.table(tidy_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)
	
	
	