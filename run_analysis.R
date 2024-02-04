
# load libraries
library(readr)
library(dplyr)

# Read feature names and assign those to column names of X_test
features <- read_delim("./UCI HAR Dataset/features.txt", col_names = c("id", "feature_name"),delim = " ")

# Read test datasets
subject_test <- read_csv("./UCI HAR Dataset/test/subject_test.txt", col_names = "subject")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "" , header = F,
                   na.strings ="", stringsAsFactors= F)

y_test <- read_csv("./UCI HAR Dataset/test/y_test.txt", col_names = "outcome") 

# Assign feature names to column names of X_test
colnames(X_test) <- features$feature_name

test <- cbind(subject_test, X_test, y_test)

# Read train datasets
subject_train <- read_csv("./UCI HAR Dataset/train/subject_train.txt", col_names = "subject") 
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "" , header = F,
                     na.strings ="", stringsAsFactors= F)

y_train <- read_csv("./UCI HAR Dataset/train/y_train.txt", col_names = "outcome")
colnames(X_train) <- features$feature_name


train <- cbind(subject_train, X_train, y_train)


sum(colnames(test) == colnames(train))

# Join the datasets
myData <- rbind(test, train)


# Extract only the measurements on the mean and standard deviation for each measurement
stdmeancols <- which(grepl("(std|mean)[(][)](-[XYZ])?$",colnames(myData)))

filteredData <- myData %>% select(subject, stdmeancols)

# Create a new dataset with mean of activity for each subject
avgValues <- filteredData %>% 
  group_by(subject) %>% 
  summarise_all(mean, na.rm=TRUE)

# Write avgValues calculated in previous step to a csv file
write.table(avgValues, file = "./output/avgValues.txt", row.names = FALSE)
