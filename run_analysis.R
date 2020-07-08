library(dplyr)
library(tidyr)

setwd("/Users/augustineden/RProgramming")

if (!file.exists("gcd_project")) {
        dir.create("gcd_project")
}

setwd("gcd_project")

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "projectfiles.zip")
dateDownloaded <- date()

unzip(zipfile = "projectfiles.zip") # Unzip the downloaded file
file.rename("UCI HAR Dataset", "uci_data") # Rename the folder containing the data - for typability

#### The code reads in the features.txt text file and edits each element
#### for readability. This will become the vector of column names.

varNames <- read.table("uci_data/features.txt", sep = "") 
columnNames <- make.names(varNames[, 2], unique = TRUE)
replaceDots<-function(x){ # function replaces periods with underscores, then tidies up the underscores
        x <- gsub("\\.", "_", x)
        x <- gsub("___", "_", x)
        x <- gsub("__$", "", x)
        x <- gsub("_$", "", x)
}
columnNames <- replaceDots(columnNames)

#### The activity_labels.txt file is read in, which allows us to identify the 
#### activities in the main data sets. This will be used later.

activityLabels <- read.table("uci_data/activity_labels.txt", sep= "") 
colnames(activityLabels) <- c("activity_label", "activity")
activityLabels$activity <- sapply(activityLabels$activity, tolower) # convert to lower case for readability

#### Now the code will read in the test activity (Y_test), subject (subject_test) 
#### and data (X_test) text files, plus the corresponding text files for the train dataset.
#### Columns that contain mean and std measurements are selected to fulfill step 2
#### of the project instructions.

testActivity <- read.table("uci_data/test/Y_test.txt", sep = "")
colnames(testActivity) <- "activity_label" # descriptive name for the column variable

testSubject <- read.table("uci_data/test/subject_test.txt", sep = "")
colnames(testSubject) <- "subject" # Descriptive name for this column variable

testData <- read.table("uci_data/test/X_test.txt", sep = "")
colnames(testData) <- columnNames # name the columns using the columnNames variable defined above

testData <- testData %>% select(contains("_mean_") | contains("_std_") | 
                                        ends_with("_mean") | ends_with("_std")) 

testData <- cbind(set = "test", testActivity, testSubject, testData) # column added with values = "test"

trainActivity <- read.table("uci_data/train/Y_train.txt", sep = "")
colnames(trainActivity) <- "activity_label"

trainSubject <- read.table("uci_data/train/subject_train.txt", sep = "")
colnames(trainSubject) <- "subject"

trainData <- read.table("uci_data/train/X_train.txt", sep = "")
colnames(trainData) <- columnNames

trainData <- trainData %>% select(contains("_mean_") | contains("_std_") | 
                                          ends_with("_mean") | ends_with("_std"))

trainData <- cbind(set = "train", trainActivity, trainSubject, trainData)

#### The 2 datasets are now merged together to form one dataset, fulfilling 
#### step 1 of the project instructions, and the activities are given descriptive names
#### thus fulfilling step 3 of the project instructions.

mergedData <- rbind(testData, trainData)
mergedData <- merge(activityLabels, mergedData, by = "activity_label")
mergedData <- mergedData %>% select(-(activity_label))

#### Now tidy the merged dataset by pivoting the data frame and separating 
#### columns that contain more than one variable. The end-game is to have the dataset
#### satisfy the 3 tennets of tidy data. This step also labels each column with a descriptive name
#### which fulfills step 4 of the project instructions.

tidyData <- mergedData %>% pivot_longer(-(activity:subject), names_to = "feature", 
        values_to = "magnitude", values_drop_na = TRUE) %>%
        separate(feature, c("domain", "feature"), 1) %>% # separate feature from domain (time, frequency)
        separate(feature, c("feature", "measurement"), "_", extra = "merge") %>%
        separate(measurement, c("measurement", "dimension"), "_", extra = "drop")

#### Assign names to the domain column where t = time and f = frequency

tidyData$domain <- gsub("t", "time", tidyData$domain)
tidyData$domain <- gsub("f", "frequency", tidyData$domain)

#### Finally, create a second, independent tidy data set giving the mean of each feature,
#### grouped by activity and subject.

summary <- tidyData %>% group_by(activity, feature, subject) %>%
  summarize(mean_magnitude = mean(magnitude))

write.csv(tidyData, "tidy_data.csv")
write.csv(summary, "summary_means.csv")
