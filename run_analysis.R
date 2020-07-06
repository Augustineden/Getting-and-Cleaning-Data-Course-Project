library(dplyr)

setwd("/Users/augustineden/RProgramming")

if (!file.exists("gcd_project")) {
        dir.create("gcd_project")
}

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "gcd_project/projectfiles.zip")
dateDownloaded <- date()

unzip(zipfile = "projectfiles.zip", exdir = "gcd_project")
setwd("gcd_project")
file.remove("projectfiles.zip")
file.rename("UCI HAR Dataset", "uci_data")
setwd("uci_data")

varNames <- read.table("features.txt", sep = "")
columnNames <- make.names(varNames[,2], unique = TRUE, allow_ = FALSE)

activityLabels <- read.table("activity_labels.txt", sep= "")
colnames(activityLabels) <- c("Activity.Label", "Activity")

testAct <- read.table("test/Y_test.txt", sep = "")
colnames(testAct) <- "Activity.Label"

testData <- read.table("test/X_test.txt", sep = "")
colnames(testData) <- columnNames
testData <- cbind(testData, testAct) %>% relocate(Activity)

Data_select <- testData %>% select(contains("mean") | contains("std"))
