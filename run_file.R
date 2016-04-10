
# Init - Set Directory path
library(dplyr)
library(data.table)

dirPath <- "C:\\Users\\rakes_000\\cleaningfinalproject"

# 1. Set the current working directory
setwd(dirPath)
print(getwd())

# 2. Download data set, unzip the file to UCI HAR Dataset folder
path <- getwd()

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
downloadPath <- file.path(path, "UCI_HAR_Dataset.zip")

if(!file.exists(downloadPath)){
  print("Downloaded Again")
  download.file(zipUrl, destfile = downloadPath, mode="wb")
}

dataSetPath <- file.path(path,"UCI HAR Dataset")
if(!file.exists(dataSetPath)){
  print("Unzipped again")
  unzip(downloadPath)
}

# 3. List files to look at the file structure
print(list.files(dataSetPath, recursive = TRUE))


# 4. Extract information about features
features <- read.table(file.path(dataSetPath,"features.txt"))
features[,2] <- as.character(features[,2])
featuresWanted <- grep(".*mean.*|.*std.*",features[,2])
featuresWanted.names <- features[featuresWanted, 2]
featuresWanted.names <- gsub("-mean","Mean",featuresWanted.names)
featuresWanted.names <- gsub("-sub","Sub",featuresWanted.names)
featuresWanted.names <- gsub("[-()]","",featuresWanted.names)
rm(features)

# 5. Activity Lables
activity_labels <- read.table(file.path(dataSetPath,"activity_labels.txt"))
activity_labels[,2] <- as.character(activity_labels[,2])

# 6. Read the files 

subjectTrain <- fread(file.path(dataSetPath, "train", "subject_train.txt"))
subjectTest <- fread(file.path(dataSetPath,"test","subject_test.txt"))

parametersTrain <- fread(file.path(dataSetPath, "train","X_train.txt"))
parametersTest <- fread(file.path(dataSetPath,"test","X_test.txt"))

parametersTrain <- select(parametersTrain, featuresWanted)
parametersTest <- select(parametersTest, featuresWanted)

labelsTrain <- fread(file.path(dataSetPath, "train","Y_train.txt"))
labelsTest <- fread(file.path(dataSetPath,"test","Y_test.txt"))

# 7. Combine Train and Test Data
subjectCombined <- rbind(subjectTrain, subjectTest)
parametersCombined <- rbind(parametersTrain, parametersTest)
labelsCombined <- rbind(labelsTrain, labelsTest)
labelsCombined <- activity_labels[labelsCombined$V1, 2]

finalResult <- cbind(subjectCombined, labelsCombined, parametersCombined)
names(finalResult) <- c("subject","activity",featuresWanted.names)
finalResult$activity <- factor(finalResult$activity) #converting to factor from character
finalResult$subject <- factor(finalResult$subject) #converting to factor from int
setkey(finalResult, subject, activity)

#Clearing variables from memory which are not required
rm(subjectTest,subjectTrain,parametersTrain,parametersTest,labelsTest,labelsTrain)
rm(subjectCombined, parametersCombined, labelsCombined, activity_labels)
rm(featuresWanted.names, featuresWanted, downloadPath, dirPath, zipUrl)

# 8. Mean over subject and activity
meanFinal <- aggregate(select(finalResult,c(3:81)),list(subject=finalResult$subject, activity=finalResult$activity), mean)
setorder(meanFinal,subject)
rownames(meanFinal) <- 1:length(rownames(meanFinal)) # Row names get changed after ordering. This resets that

# 9. Write the meanFinal into tidy.txt
write.table(meanFinal, file=file.path(path, "tidy.txt"))
