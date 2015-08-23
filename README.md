---
title: "Human Activity Recognition - Tidy Dataset"
author: "Erick Fuentes"
date: "22 de agosto de 2015"
output: html_document
---

# run_analysis
Script for converting HAR data into a tidy dataset

The script uses the datasets from the study "Human Activity Recognition  Using Smartphones" -- http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

First is loads the activity labels and features from the files ataset/activity_labels.txt and dataset/features.txt.

Then the train and test files are loaded. Subjects and activities are combined with the main datasets (with cbind)

The next step is to rbind the train and test data frames into one (msData). Since we only need the mean and standard deviation measures, we use a select command (with contains feature chosing std and mean)

Via a couple of nested for loops, the script traverses the msData data frame calculating the mean of all the variables for each activity - subject pair. This creates a tidy data set that finally is saved to a file (tidydata.txt)


