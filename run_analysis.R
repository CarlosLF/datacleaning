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

# Use descriptive activity names to name the activities in the data set
names(x_data)<- features_names[ind_mean_std]

activities = read.table('./activity_labels.txt')
activityLabels= activities[,2]

y_data[,1]<-activityLabels[y_data[,1]]

names(y_data)<- "activity"
names(subject_data)<- "subject"

# tidy data set 
tidy_data<- cbind(x_data,y_data,subject_data)

# tidy data set with the average of each variable for each activity and each subject
avg_data <- ddply(tidy_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

#save tidy data
write.table(avg_data, "average_data.txt", row.name=FALSE)

