# Codebook

The features selected for this database come from the accelerometer and gyroscope 
3-axial raw signals tAcc-XYZ and tGyro-XYZ. 

The time domain signals (labelled "time" in the domain column of the dataset) were 
captured at a constant rate of 50 Hz. Then they were filtered using a median filter
and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to 
remove noise. 

Similarly, the acceleration signal was then separated into body and gravity 
acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ).

The body linear acceleration and angular velocity were derived in time to obtain 
Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). 

Also, the magnitude of these three-dimensional signals were calculated using the 
Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, 
tBodyGyroJerkMag). 

A Fast Fourier Transform (FFT) was applied to some of these signals producing 
fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, 
fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

run_analysis.R splits each feature into domain and dimension components, thus
simplifying the list of featres into:

1. BodyAcc-XYZ
2. GravityAcc-XYZ
3. BodyAccJerk-XYZ
4. BodyGyro-XYZ
5. BodyGyroJerk-XYZ
6. BodyAccMag
7. GravityAccMag
8. BodyAccJerkMag
9. BodyGyroMag
10. BodyGyroJerkMag
11. BodyBodyAccJerkMag
12. BodyBodyGyroMag
13. BodyBodyGyroJerkMag

Measurements on linear Acceleration, from the Accelerometer, are in m/s^2

Measurements on Angular Velocity, from the Gyroscope, are in Rad/s^2
