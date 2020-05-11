## set the wd, download the data, and unzip the data
library(data.table)
setwd(""~/R.Studio/Getting_and_Cleaning_Data/Getting_and_cleaning_data_project"")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "data.zip" )
unzip("data.zip")

## set the new wd as the data file, and list all the files
setwd("~/R.Studio/Getting_and_Cleaning_Data/Getting_and_cleaning_data_project/UCI HAR Dataset")
train_files <- list.files("train", full.names = T)
test_files <- list.files("test", full.names = T)

## combine all the data together, for easy read the data, exclude the Interial Signals file
files <- c(train_files, test_files)[c(2,3,4,6,7,8)]
## there's an error to read the data using the name in the file, due to the accesibility of the WD
## using the paste0 function to paste the full name to the location of the file
files1<- paste0("~/R.Studio/Getting_and_Cleaning_Data/Getting_and_cleaning_data_project/UCI HAR Dataset/", files)

## use the lappy function to loop read all the data file
dat <- lapply(files1, read.table, stringsAsFactors = F, header = F)

## rbind the train and test data, subject_train with subject_test, X_test with X_train, y_test with y_train
dat1 <- mapply ( rbind, dat[ c(1:3) ], dat[ c(4:6) ] )

## cbind all the variables, col1 = subject, col2-562 = features, col563 = activity numbers
dat2 <- do.call( cbind, dat1 )

## read all the feature names from the wd, file"features.txt"
feature_name <- fread( list.files()[2], header = F, stringsAsFactor = F)

## set the name of all the columns in dat2, col1 = subject, col2-562 = features, col563 = activity numbers
colnames(dat2) <- c( "subject", feature_name$V2, "activity" ) 

## find all the feature_names with "mean", or "std"
stdandmean <- grep( "std|mean\\(\\)", feature_name$V2)

##the column1 in dat2 is subject, therefore, the real column selected should be stdandmean+1
realstdandmean <- stdandmean + 1

## select the columns with mean and std to dat3
dat3 <- dat2[, c( 1, realstdandmean, 563 ) ]

## find the activity names from "activity_labels"file
activity_name <- fread( list.files()[1], header = F, stringsAsFactor = F)

## match all the activity in Col to the names in activity_name
dat3$activity <- activity_name$V2[ match( dat3$activity, activity_name$V1 ) ]

## use the aggregate function to get the mean of rach variable for each activity and subject
dat4 <- aggregate( . ~ subject + activity, data = dat3, FUN = mean )

## write the dat4 into a table, name is "averagedata.txt
write.table(dat4, "averagedata.txt", row.names = F)

