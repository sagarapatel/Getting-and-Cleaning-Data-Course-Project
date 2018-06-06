
#Run library readtext
library(readtext)

# Load Activity Labels and Column Names
activity_labels <- read.table("./R DATA/C3W4A1/getdata/UCI HAR Dataset/activity_labels.txt", header=FALSE)
column_names <- read.table("./R DATA/C3W4A1/getdata/UCI HAR Dataset/features.txt", header=FALSE)

# Load Training Data Files
train_subjects <- read.table("./R DATA/C3W4A1/getdata/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
train_data <- read.table('./R DATA/C3W4A1/getdata/UCI HAR Dataset/train/X_train.txt')
train_labels <- read.table("./R DATA/C3W4A1/getdata/UCI HAR Dataset/train/y_train.txt", header=FALSE)

# Load Test Data Files
test_subjects <- read.table("./R DATA/C3W4A1/getdata/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
test_data <- read.table('./R DATA/C3W4A1/getdata/UCI HAR Dataset/test/X_test.txt')
test_labels <- read.table("./R DATA/C3W4A1/getdata/UCI HAR Dataset/test/y_test.txt", header=FALSE)

# 1 : Merge Training and Test Data Files
merged_data <- rbind(test_data, train_data)
merged_labels <- rbind(test_labels, train_labels)
merged_subjects <- rbind(test_subjects, train_subjects)

# 2 : Extracts only columns of merged data with mean or std words inside using grep function
merged_subset <- merged_data[ , grep("mean|std", colnames(merged_data))]

# 3 : Assign descriptive activity names to activity numbers
merged_labels$Activity <- activity_labels[merged_labels$V1, 2]

# 4 : Assign descriptive variable names to all data sets
colnames(merged_data) <- column_names$V2
names(merged_labels)[1] <- "Activity ID"
names(merged_subjects) <- "Subjects"

# 5 : Merge all data set into one and tidy it with aggregate function
merged_all <- cbind(merged_subjects, merged_labels, merged_data)
tidy_dataset <- aggregate(.~Subjects+Activity, merged_all, mean)

# Write Tidy Data at give destination
write.table(tidy_dataset, file = "./tidy_dataset.txt", quote=FALSE, sep="\t", row.names = FALSE)
