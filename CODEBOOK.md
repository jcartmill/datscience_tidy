---
title: "CODEBOOK"
output: html_document
author: John Cartmill
class:  Getting and Cleaning Data
---

##Code Book
This data set is taken from Human Activity Recognition Using Smartphones Data Set[1].

###Data Overview:  
The original data set consists from 30 subjects performing six activities.
The original data set consists of two separate sets a training set and a test set.
There are 561 features of time and frequency domain variables. 

The final "tidy set" consists of 180 rows (30 subjects times 6 activities) and 60 columns of mean and standard deviations taken from the 561 original features.  

**Subjects:** There are 30 subjects identified by integer id from 1 to 30.  

**Activities:**  
There are six activities:  
1. LAYING  
2. SITTING  
3. STANDING  
4. WALKING  
5. WALKING_DOWNSTAIRS  
6. WALKING_UPSTAIRS  
  
**Features: **  

The only two feature groups retained for the final "tidy data set" are the  mean(): Mean value  and the std(): Standard deviation.  
This feature description comes directly for the study authors:   
```
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

** mean(): Mean value   Note: These data are included in the final data set
** std(): Standard deviation  Note: These data are included in the final data set
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean
```


###Data Processing Steps
1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

####Read in all of the data using read.table

From the train subdirectory  
  * X_train.txt  
  * y_train.txt  
  * subject_train.txt  

From the test subdirectory  
 + X_test.txt  
 + y_test.txt  
 + subject_test.txt  
 
*Example:*   x_train <-read.table("UCI HAR Dataset//train//X_train.txt")  

####Merge the two sets using rbind

*Example:* x_all <- rbind(x_train,x_test)  
repeat for y_train,y_test and s_train,s_test  
 **This completes step 1. **  


####Read all of the text labels from the base directory
activity_labels.txt  
features.txt  
Search for features that have mean and std using the grep command  
*Example:* f_means <-grep ("mean\\(",f[,2])  



####Assign Column Labels
 

colnames(y_labels_frame) <-c("activity")  
colnames(s_all)<- c("subject")  
colnames(x_all)<-f_labels$V2  
 **This completes step 3. **  

####Get just mean and std columns
x_std<-x_all[,f_std]  
x_mean<-x_all[,f_means]  

####Push together with column bind (cbind)
s_all are the subjects  
y_labels_frame are the activities  
x mean are the means and x_std are the standard deviations.  
*Example: * all_data <-cbind(s_all,y_labels_frame,x_mean,x_std)  
**This completes step 2.**   

####Sort by Subject number
```
sort_data<-all_data[order(all_data$Subject,all_data$activity),]
```

####Loop to get column means for each subject and activity
```
vx = TRUE
for (i in  unique(sort_data$subject)){
        for (j in  unique(sort_data$activity)){
                #  Get colmeans for each subject and activity
                tmp_df<-rbind(colMeans(sort_data[sort_data$Subject== i & sort_data$Activity == j ,3:length(sort_data)]))
                adf <- data.frame(j)
                sdf <- data.frame(i)
                
                colnames(adf) <-c("activity")
                colnames(sdf)<- c("subject")
                
                mean_df<-cbind(sdf,adf,tmp_df)
                
                if (vx){
                        out_df = mean_df
                        vx = FALSE
                } else{
                out_df<-rbind(out_df,mean_df)
                }
        }
        
}
```
**This completes step 4.**  

####Output Table to csv File
The final column names are converted to lower case and remove the "-'s" and "()'s"  
*Example:* tolower(gsub("-|\\()", "", colnames(out_df)))    
write.table(out_df,"UCI HAR Dataset//tidy_data.txt",sep=",",row.names=FALSE)  
**This completes the project.**  

####Refernces

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012