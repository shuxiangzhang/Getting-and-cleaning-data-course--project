library(plyr)

# Download the project data set from spicied website and unzip it to a folder
if(!file.exists('dataset')){dir.create('dataset')}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile='./dataset/project_dataset.zip')
unzip(zipfile='./dataset/project_dataset.zip',exdir='./dataset')

# Read data from files into R
path_1<-file.path('./dataset','UCI HAR Dataset')
activity_labels<-read.table(file.path(path_1,'activity_labels.txt'),header=FALSE)
features<-read.table(file.path(path_1,'features.txt'))
subject_test<-read.table(file.path(path_1,'test','subject_test.txt'),header=FALSE)
X_test<-read.table(file.path(path_1,'test','X_test.txt'),header=FALSE)
y_test<-read.table(file.path(path_1,'test','y_test.txt'),header=FALSE)
subject_train<-read.table(file.path(path_1,'train','subject_train.txt'),header=FALSE)
X_train<-read.table(file.path(path_1,'train','X_train.txt'),header=FALSE)
y_train<-read.table(file.path(path_1,'train','y_train.txt'),header=FALSE)

# Appropriately labels the data set with descriptive variable names
X<-rbind(X_test,X_train)
names(X)<-features[,2]
subject<-rbind(subject_test,subject_train)
names(subject)<-'subject'

# Uses descriptive activity names to name the activities in the data set
activity_number<-rbind(y_test,y_train)
activity_number[,1]<-activity_labels[activity_number[,1],2]
names(activity_number)<-'activity'

# Extracts only the measurements on the mean and 
#standard deviation for each measurement
featurenumber_extracted <- grep(".*mean.*|.*std.*", features[,2])
X<-X[,featurenumber_extracted]

# Merges the training and the test sets to create one data set
combined_data<-cbind(subject,activity_number,X)

# From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject

Average_data<-ddply(combined_data,c('subject','activity'),function(x){colMeans(x[,-(1:2)])})
write.table(Average_data, "tidy.txt", row.name=FALSE)
