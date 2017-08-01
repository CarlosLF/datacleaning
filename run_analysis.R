library(plyr)

# Read train data
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/Y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

# Read test data
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/Y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# merge data
x_data0 <- rbind(x_train,x_test)
y_data <- rbind(y_train,y_test)
subject_data <- rbind(subject_train, subject_test)


# Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table('./features.txt')
features_names <- features[,2]
ind_mean_std <- grep("(mean|std)\\(", features_names)
x_data<- x_data0[,ind_mean_std]

# Uses descriptive activity names to name the activities in the data set
new_names<- features_names[ind_mean_std]
new_names<- gsub('-mean\\(\\)', 'Mean', new_names)
new_names<- gsub('-std\\(\\)', 'Std', new_names)
new_names<- gsub('-', '', new_names)

names(x_data)<- new_names

activities = read.table('./activity_labels.txt')
activityLabels= activities[,2]

y_data[,1]<-activityLabels[y_data[,1]]

names(y_data)<- "activity"
names(subject_data)<- "subject"

# tidy data set with the average of each variable for each activity and each subject
data<- cbind(x_data,y_data,subject_data)

tidy_data <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]))

#save data
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)

