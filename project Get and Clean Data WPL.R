#Proyect Getting and Cleaning data

#You should create one R script called run_analysis.R that does the following.

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each

#1. Merges the training and the test sets to create one data set.
#Getting data
   
activityLabels<-read.table("./project/UCI HAR Dataset/activity_labels.txt",col.names = c("code", "activity"))
features<-read.table("./project/UCI HAR Dataset/features.txt",col.names = c("n","functions"))
subjectTest<-read.table("./project/UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
X_test<-read.table("./project/UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
Y_test<-read.table("./project/UCI HAR Dataset/test/Y_test.txt",col.names = "code")
subjectTrain<-read.table("./project/UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
X_train<-read.table("./project/UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
Y_train<-read.table("./project/UCI HAR Dataset/train/y_train.txt",col.names = "code")

#merge table

X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
Subject <- rbind(subjectTrain, subjectTest)
Merged_Data <- cbind(Subject, Y, X)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

library(dplyr)
Measurement <- select(Merged_Data,subject, code, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set

Measurement$code <- activityLabels[Measurement$code, 2]

#4. Appropriately labels the data set with descriptive variable names.

names(Measurement)[1] = "Subject"
names(Measurement)[2] = "Activity"
names(Measurement)<-gsub("Acc", "Accelerometer", names(Measurement))
names(Measurement)<-gsub("Gyro", "Gyroscope", names(Measurement))
names(Measurement)<-gsub("BodyBody", "Body", names(Measurement))
names(Measurement)<-gsub("Mag", "Magnitude", names(Measurement))
names(Measurement)<-gsub("^t", "Time", names(Measurement))
names(Measurement)<-gsub("^f", "Frequency", names(Measurement))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each

finalData_WPL <- Measurement %>%
        group_by(Subject, Activity) %>%
        summarise_all(list(mean))
write.table(finalData_WPL, "./project/FinalData_WPL.txt", row.name=FALSE)




            