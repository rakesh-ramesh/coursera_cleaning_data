## ReadMe
#### Author: Rakesh Ramesh
#### Date: 04-10-2016

## Getting and Cleaning Data - Coursera Project

### This is the course project for the Getting and Cleaning Data Coursera course. 

### Initialization
* Set the working Directory in run_analysis.R. Variable Name is **dirPath**

### The R Script run_analysis.R does the following
* Downloads the dataset if it does not already exist in the working directory
* Unzips the dataset. This leads to creation of folder **UCI HAR Dataset**
* (optional) List files present in the dataset for reference 
* Extracts feature names only referencing mean or standard deviation from the file **features.txt**, makes feature names adhere to the standard format by removing special characters and using camelCasing.
* Extracts activity lables from the file **activity_labels.txt**
* Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
* Loads the activity and subject data for each dataset
* Converts the activity and subject columns into factors and Merges all the datasets together into **finalResult**
* From **finalResult**, creates a second, independent tidy data set with the average of each variable for each activity and each subject - **meanFinal**.
* Writes this table into file **tidy.txt**