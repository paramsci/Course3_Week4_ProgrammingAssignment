#Class Project for Course3 - Parikshit Mehta - 08-29-2017 


#Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.

homepath <- "C:\\Users\\Parikshit\\Documents\\Coursera_Data_Scientist_Spec\\Coursera_3\\project"
# read the file to get the feature name
feature1 <- read.csv(paste(homepath,"\\UCI HAR Dataset\\features.txt",sep = ""),
                     header = FALSE,sep = " ",row.names = 1,col.names = c("ind","feature"))
# read the file to get the activity label
activity_lab <- read.csv(paste(homepath,"\\UCI HAR Dataset\\activity_labels.txt",sep =""),
                         header = FALSE,sep = " ",row.names = 1, col.names = c("ind","activity_label"))
# now read the X and Y train 
Xtrain <- read.csv(paste(homepath,"\\UCI HAR Dataset\\train\\X_train.txt",sep=""),
                   header = FALSE,
                   col.names = feature1$feature, sep = "")
ytrain <- read.csv(paste(homepath,"\\UCI HAR Dataset\\train\\y_train.txt",sep=""),
                   header = FALSE,
                   sep = "")
ytrain_act <- factor(ytrain$V1, levels = 1:6, labels = activity_lab$activity_label)

# read the train subject data
subtrain <- read.csv(paste(homepath,"\\UCI HAR Dataset\\train\\subject_train.txt",sep=""),
                     header = FALSE,
                     sep = "",col.names = "Subject")

# repeat for X and Y test

Xtest <- read.csv(paste(homepath,"\\UCI HAR Dataset\\test\\X_test.txt",sep=""),
                   header = FALSE,
                   col.names = feature1$feature, sep = "")
ytest <- read.csv(paste(homepath,"\\UCI HAR Dataset\\test\\y_test.txt",sep=""),
                   header = FALSE,
                   sep = "")
ytest_act <- factor(ytest$V1, levels = 1:6, labels = activity_lab$activity_label)
# read the subject data for test
subtest <- read.csv(paste(homepath,"\\UCI HAR Dataset\\test\\subject_test.txt",sep=""),
                      header = FALSE,
                      sep = "", col.names = "Subject")

## now create data frames for test and train using X and y matrices
testdf <- as.data.frame(cbind(Xtest,ytest,subtest))
traindf <- as.data.frame(cbind(Xtrain,ytrain,subtrain))
# Merge datasets using rbind
df <- rbind(testdf,traindf)
## Now create a subset that only has mean or stf of each variable
temp1 <- grep('mean|std',names(df))
activities <- factor(df$V1, levels = 1:6,labels = activity_lab$activity_label)
subdf <- select(df,temp1,activities,Subject)
subdf <- cbind(subdf,activities)
### Tidy dataset - grouped by Activity & subject
tidy1 <- subdf %>% group_by(activities,Subject) %>%  summarise_all(funs(mean(.,na.rm = TRUE)))

