#Week 4 Project Coursera Getting and Cleaning Data
#==================================================
#COursera Data Science 

library(dplyr) #required package to clean data


#download file

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#unzip file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#list of files
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files


#read the files
dataActivityTest <- read.table(file.path(path_rf, "test", "Y_test.txt"), header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"), header=FALSE)

#read the subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"), header= FALSE)
dataSubjectTest <- read.table(file.path(path_rf, "test", "subject_test.txt"), header=FALSE)

#Read featured files
dataFeaturesTest <- read.table(file.path(path_rf, "test", "X_test.txt"), header= FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"), header=FALSE)


#RBIND Data Tables
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

#Variable Names
names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesName <- read.table(file.path(path_rf, "features.txt"), head=FALSE)
names(dataFeatures) <- dataFeaturesName$V2

#merge columns
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#subject name
subdataFeaturesNames <- dataFeaturesName$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesName$V2)]

#subset data
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
Data<- subset(Data, select=selectedNames)
str(Data)


#read activity labels
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#change labels
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#step 4
#write tidydata
Data2 <- aggregate(.~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject, Data2$activity),]
write.table(Data2, file = "tidydata.csv", row.name=FALSE)

