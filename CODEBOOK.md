---
title: "CODEBOOK"
output: html_document
---

Code Book

Data Overview:

**Activities:**
- LAYING
- SITTING
- STANDING
- WALKING



####Data Processing Steps
1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

**Read in all of the data using read.table**

From the train subdirectory
  * X_train.txt
  * y_train.txt
  * subject_train.txt

From the test subdirectory
 + X_test.txt
 + y_test.txt
 + subject_test.txt
 
*Example:* x_train <-read.table("UCI HAR Dataset//train//X_train.txt")

####Merge the two sets using rbind

Example:x_all <- rbind(x_train,x_test)
repeat for y_train,y_test and s_train,s_test
This completes step 1.


####Read all of the text labels from the base directory
activity_labels.txt
features.txt
Search for features that have mean and std using the grep command
Example: f_means <-grep ("mean",f[,2])



####Assign Column Labels
y_labels <-a_labels$V2[y_all[,]]
y_labels_frame<-data.frame(y_labels)

colnames(y_labels_frame) <-c("activity")
colnames(s_all)<- c("subject")
colnames(x_all)<-f_labels$V2

####Get just mean and std columns
x_std<-x_all[,f_std]
x_mean<-x_all[,f_means]

####push together
all_data <-cbind(s_all,y_labels_frame,x_mean,x_std)
This completes step 2.

####Sort by Subject number
sort_data<-all_data[order(all_data$Subject,all_data$activity),]
out_df<-sort_data[1,]
out_df[-1,]
####Loop to get columnmeans for each subject and activity
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

####Output Table to csv File
new_names<-tolower(gsub("-|\\()", "", colnames(out_df)))
colnames(out_df)<-new_names
write.table(out_df,"UCI HAR Dataset//tidy_data.txt",sep=",",row.names=FALSE)
write.table(out_df,"UCI HAR Dataset//tidy_data.txt",sep=",",row.names=FALSE)

