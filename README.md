
**Purpose:** This data set is taken from Human Activity Recognition Using Smartphones Data Set[1]. The data is manipulated to illuststrate proficeincy in implementing and documenting the principles of "Tidy Data" outlined in the course.

**Data Description:** 
The original data set consists from 30 subjects performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a Samsung Galaxy S II smartphone.  
The data set was randomly partitioned into two sets, where 70% is training data and 30% the test data.  
The original data set consists of 561 features of time and frequency domain variables.  


**Methodology:**
The following requirements were given for the course project:  
1.  Merge the training and the test sets to create one data set.  
2.  Extract only the measurements on the mean and standard deviation for each   measurement. 
3.  Use descriptive activity names to name the activities in the data set  
4.  Appropriately label the data set with descriptive variable names.   
5.  Create a second, independent tidy data set with the average of each variable for each activity and each subject.  


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

####References

https://github.com/jcartmill/datscience_tidy/blob/master/CODEBOOK.md  

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012