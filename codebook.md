---
title: "Codebook"

---


Codebook

Codebook created on 2020-07-09 13:11:30

List of variables in summary_means.txt dataset


```r
names(tidySummary)
```

```
##  [1] "subject"    "activity"   "domain"     "dimension"  "component"  "instrument" "jerk"       "magnitude"  "statistic"  "count"     
## [11] "mean_value"
```

------------------------------

Variable name    | Description
-----------------|------------
subject          | participant ID - numeric between 1 and 30
activity         | activity name
domain           | indicates time or frequency domain
dimension        | 3-axial dimension component (x, y, z)
component        | acceleration component measured (body or gravity)
instrument       | instrument making measurement (accelerometer or gyroscope)
jerk             | indicates jerk measurement
magnitude        | indicates magnitude measurement
statistic        | indicates mean or standard deviation calculation
count            | number of observations used to calculate mean_value
mean_value       | mean value calculated for each observation

The dataset summary_means.txt is created by the run_analysis.R code and has the 
following structure:


```r
str(tidySummary, max.level = 2)
```

```
## tibble [11,880 × 11] (S3: grouped_df/tbl_df/tbl/data.frame)
##  $ subject   : Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ activity  : Factor w/ 6 levels "laying","sitting",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ domain    : Factor w/ 2 levels "frequency","time": 1 1 1 1 1 1 1 1 1 1 ...
##  $ dimension : Factor w/ 3 levels "X","Y","Z": 1 1 1 1 1 1 2 2 2 2 ...
##  $ component : Factor w/ 3 levels NA,"body","gravity": 1 1 2 2 2 2 1 1 2 2 ...
##  $ instrument: Factor w/ 2 levels "accelerometer",..: 2 2 1 1 1 1 2 2 1 1 ...
##  $ jerk      : Factor w/ 2 levels NA,"jerk": 1 1 1 1 2 2 1 1 1 1 ...
##  $ magnitude : Factor w/ 2 levels NA,"magnitude": 1 1 1 1 1 1 1 1 1 1 ...
##  $ statistic : Factor w/ 2 levels "mean","std": 1 2 1 2 1 2 1 2 1 2 ...
##  $ count     : int [1:11880] 50 50 50 50 50 50 50 50 50 50 ...
##  $ mean_value: num [1:11880] -0.85 -0.882 -0.939 -0.924 -0.957 ...
##  - attr(*, "groups")= tibble [5,940 × 9] (S3: tbl_df/tbl/data.frame)
##   ..- attr(*, ".drop")= logi TRUE
```

First few rows of the dataset:


```r
as_tibble(tidySummary)
```

```
## # A tibble: 11,880 x 11
##    subject activity domain    dimension component instrument    jerk  magnitude statistic count mean_value
##    <fct>   <fct>    <fct>     <fct>     <fct>     <fct>         <fct> <fct>     <fct>     <int>      <dbl>
##  1 1       laying   frequency X         <NA>      gyroscope     <NA>  <NA>      mean         50     -0.850
##  2 1       laying   frequency X         <NA>      gyroscope     <NA>  <NA>      std          50     -0.882
##  3 1       laying   frequency X         body      accelerometer <NA>  <NA>      mean         50     -0.939
##  4 1       laying   frequency X         body      accelerometer <NA>  <NA>      std          50     -0.924
##  5 1       laying   frequency X         body      accelerometer jerk  <NA>      mean         50     -0.957
##  6 1       laying   frequency X         body      accelerometer jerk  <NA>      std          50     -0.964
##  7 1       laying   frequency Y         <NA>      gyroscope     <NA>  <NA>      mean         50     -0.952
##  8 1       laying   frequency Y         <NA>      gyroscope     <NA>  <NA>      std          50     -0.951
##  9 1       laying   frequency Y         body      accelerometer <NA>  <NA>      mean         50     -0.867
## 10 1       laying   frequency Y         body      accelerometer <NA>  <NA>      std          50     -0.834
## # … with 11,870 more rows
```
