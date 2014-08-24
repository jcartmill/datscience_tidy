#Purpose:

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Read in all of the data
x_train <-read.table("UCI HAR Dataset//train//X_train.txt")
y_train <-read.table("UCI HAR Dataset//train//y_train.txt")
s_train <-read.table("UCI HAR Dataset//train//subject_train.txt")

x_test <-read.table("UCI HAR Dataset//test//X_test.txt")
y_test <-read.table("UCI HAR Dataset//test//y_test.txt")
s_test <-read.table("UCI HAR Dataset//test//subject_test.txt")

#Merge the two sets
x_all <- rbind(x_train,x_test)
y_all <- rbind(y_train,y_test)
s_all <- rbind(s_train,s_test)

#Read all of the text labels
a_labels <-read.table("UCI HAR Dataset//activity_labels.txt")
f_labels <-read.table("UCI HAR Dataset//features.txt")
f_means <-grep ("mean",f[,2])
f_std <-grep ("std",f[,2])


#Assign Column Labels
y_labels <-a_labels$V2[y_all[,]]
y_labels_frame<-data.frame(y_labels)
colnames(y_labels_frame) <-c("activity")
colnames(s_all)<- c("subject")
colnames(x_all)<-f_labels$V2

#Get just mena and std columns
x_std<-x_all[,f_std]
x_mean<-x_all[,f_means]

#push together
all_data <-cbind(s_all,y_labels_frame,x_mean,x_std)

##Sort by Subject number
sort_data<-all_data[order(all_data$subject,all_data$activity),]
out_df<-sort_data[1,]
out_df[-1,]
#Loop to get columnmeans for each subject and activity
vx = TRUE

for (i in  unique(sort_data$subject)){
        for (j in  unique(sort_data$activity)){
                #  Get colmeans for each subject and activity
                tmp_df<-rbind(colMeans(sort_data[sort_data$subject== i & sort_data$activity == j ,3:length(sort_data)]))
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
#Output Table to csv File
new_names<-tolower(gsub("-|\\()", "", colnames(out_df)))
colnames(out_df)<-new_names
write.table(out_df,"UCI HAR Dataset//tidy_data.txt",sep=",",row.names=FALSE)





