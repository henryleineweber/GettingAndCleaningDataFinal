#Getting and Cleaning Data Week 4 - Final Project

The R script "run_analyis.r" written for the Geting and Cleaning Data final project does the following:

1. Sets working directory to a folder in your current directory called "RunAnalyis". The zip folder containing the project data is downloaded and extracted here.
2. All files in the extracted folder are read into R and assigned a name in the environment.
3. Column names are defined.
4. All training data files are merged together and all test files are merged together. These consolidated dataframes are then merged.
5. Mean and Standard Deviation columns are extracted and a subset of data is created.
6. Column names are standardized and unnecessary symbols removed.
7. Means are calculated and a tidy data set is exported.

The result of this script should be a file called "tidy_data.txt" that is saved in the "RunAnalysis" folder.
