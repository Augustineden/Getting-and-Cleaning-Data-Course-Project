library(dplyr)
library(tidyr)
library(knitr)

setwd("/Users/augustineden/RProgramming/gcd_project")

if (!file.exists("gcd_project")) {
        dir.create("gcd_project")
}


fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "projectfiles.zip")
dateDownloaded <- date()

unzip(zipfile = "projectfiles.zip") # Unzip the downloaded file
file.rename("UCI HAR Dataset", "uci_data") # Rename the folder containing the data - for typability

#### The code reads in the features.txt text file and edits each element
#### for readability. This will become the vector of column names.

varNames <- read.table("uci_data/features.txt", sep = "") 
columnNames <- make.names(varNames[, 2], unique = TRUE) # remove illegal characters from varNames
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

Data <- mergedData %>% pivot_longer(-(activity:subject), names_to = "feature", 
        values_to = "value", values_drop_na = TRUE) %>%
        separate(feature, c("domain", "feature"), 1) %>% # separate feature from domain (time, frequency)
        separate(feature, c("feature", "statistic"), "_", extra = "merge") %>%
        separate(statistic, c("statistic", "dimension"), "_", extra = "drop")

findMe <- function(x) { # further separation relies upon searching for keywords in feature column
        grepl(x, Data$feature)
}

n <- 2
y <- matrix(seq(1, n), nrow = n)

x <- matrix(c(findMe("Acc"), findMe("Gyro")), ncol = nrow(y))
Data$instrument <- factor(x %*% y, labels = c("accelerometer", "gyroscope"))

x <- matrix(c(findMe("BodyAcc"), findMe("GravityAcc")), ncol = nrow(y))
Data$component <- factor(x %*% y, labels = c(NA, "body", "gravity"))

Data$jerk <- factor(findMe("Jerk"), labels = c(NA, "jerk"))

Data$magnitude <- factor(findMe("Mag"), labels = c(NA, "magnitude"))

#### Assign names to the domain column where t = time and f = frequency

Data$domain <- gsub("t", "time", Data$domain)
Data$domain <- gsub("f", "frequency", Data$domain)
Data <- Data %>% mutate_if(is.character, as.factor)
Data$subject <- as.factor(Data$subject)

#### Finally, create a second, independent tidy data set giving the mean of each feature,
#### grouped by activity and subject.

tidyData <- Data %>% select(c(activity:domain, dimension, instrument:magnitude, statistic, value))
tidySummary <- tidyData %>% select(c(activity:domain, dimension, instrument:value)) %>% 
  group_by(subject, activity, domain, dimension, component, instrument, jerk, 
           magnitude, statistic) %>%
  summarize(count = n(), mean_value = mean(value))

write.table(tidyData, "tidy_data.txt", row.name = FALSE)
write.table(tidySummary, "summary_means.txt", row.name = FALSE)

knit("makeCodebook.Rmd", output = "codebook.md", encoding = "ISO8859-1", quiet = TRUE)
