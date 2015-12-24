#GCD Week3 Assignment 
##1.Merges the training and the test sets to create one data set.
### Reading the Files from your wd###

TestFeature<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

TestActivity<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

TestSubject<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

TrainFeature<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")

TrainActivity<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

TrainSubject<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

### Rbind and merge the similar files ###

Feature<-rbind(TestFeature,TrainFeature)

Activity<-rbind(TestActivity,TrainActivity)

Subject<-rbind(TestSubject,TrainSubject)

###Check the Column Names### and read the header and assign to feature
names(Feature)<-FeatureHeaders[,2]

##read the header from features.txt
FeatureHeaders<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

View(FeatureHeaders)

##set header as Activities
names(Activity)<-"Activities"

##set header as Subjects
names(Subject)<-"Subjects"

##Finally Merger the data 
HumanActivityData<-cbind(Feature,Activity,Subject)

-------------------------------------------------------------------------------------------------------
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 

View(HumanActivityData) 

?grep
 
##using Grep and find the mean and std columns and assing it to a variable               
Measurements<-grep(".*Mean.*|.*Std.*", names(HumanActivityData), ignore.case=TRUE) 

CompleteMeasurementsdata<-c(Measurements,562,563)

MeanStdData<-HumanActivityData[,CompleteMeasurementsdata]

View(MeanStdData)

---------------------------------------------------------------------------------------------------------
##3.Uses descriptive activity names to name the activities in the data set

ActivityLabel<-read.table("C:/Users/ssdala/Desktop/R/assigment/GCD Week3 Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

ActivityLabel

MeanStdData$Activities<-as.character(MeanStdData$Activities)

for (i in 1:6){

        MeanStdData$Activities[MeanStdData$Activities==i]<- as.character(ActivityLabel[i,2])        
        
}

View(MeanStdData)
--------------------------------------------------------------------------------------------------------
## 4.Appropriately labels the data set with descriptive variable names.    

names(MeanStdData)<-gsub("Acc","Accelerometer",names(MeanStdData))        
names(MeanStdData)<-gsub("Gyro","Gyroscope",names(MeanStdData))
names(MeanStdData)<-gsub("-mean()","Mean",names(MeanStdData))
names(MeanStdData)<-gsub("-std()","STD",names(MeanStdData))
names(MeanStdData)<-gsub("-freq()","Frequency",names(MeanStdData))
names(MeanStdData)<-gsub("angle","Angle",names(MeanStdData))        
names(MeanStdData)<-gsub("gravity","Gravity",names(MeanStdData))        


View(MeanStdData)
------------------------------------------------------------------------------------------------------
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.        

MeanStdData$Activities <- as.factor(MeanStdData$Activities)
MeanStdData$Subjects <- as.factor(MeanStdData$Subjects)
library(data.table)
MeanStdData<- data.table (MeanStdData)
tidyData <- aggregate(. ~Subjects + Activities,MeanStdData, mean)
tidyData <-tidyData[order(tidyData$Subjects,tidyData$Activities),]
write.table(tidyData,file="Tidy.txt",row.names = FALSE)


