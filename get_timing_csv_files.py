#### querySql.py -- script for converting clock-synchronization data (between Plexon and Picto)
#### from .sqlite database form -> .csv form. MATLAB scripts take the .csv clock times as inputs
#### when looking at LFP data.

import sqlite3
import os
import csv
import glob # for getting directory items

didComplete = 0
while didComplete == 0: # use while loop to determine whether to use default data and save directories, or have user input their own
	require_user_input = raw_input('\nSpecify whether to run automatically (0) or\nwith manual input for directory names (1)> ')
	if require_user_input == '1' or require_user_input == '0': # if valid value for require_user_input ...
		didComplete = 1
	else:
		print('\nPlease input 1 (run manually) or 0 (run automatically); do not use quotation marks')

if require_user_input == '0':
	dataDirectory = '/Volumes/My Passport/NICK/Chang Lab 2016/LFP/Olgas_Data_Targac/12012015/'
	saveDirectory = '/Users/Nick/Desktop/py_test/outputs'
else:
	dataDirectory = raw_input('\nEnter name of the directory that houses your .sqlite files> ')
	saveDirectory = raw_input('\nEnter the name of the directory in which to save .csv files, or input: same to use the .sqlite directory> ')

	if saveDirectory == 'same':
		saveDirectory = dataDirectory

os.chdir(dataDirectory)
fileNames = glob.glob('*.sqlite') # get all the database files

for l in range(len(fileNames)): # for each database file ...
	print('\nProcessing File %d of %d') % (l+1,len(fileNames))
	fullFile = os.path.join(dataDirectory,fileNames[l]) # get full patch to file

	print('\n\tLoading database file ...')
	conn = sqlite3.connect(fullFile) # load the file
	c = conn.cursor() # prep the file for querying

	print('\n\tAttempting to query database ...')
	query = 'SELECT neuraltime,behavioralTime FROM alignevents;'
	selected = c.execute(query) # get the neural time and behavioral time columns
	csvFileName = '%s.csv' % fileNames[l] # prep for a new .csv file

	os.chdir(saveDirectory) # cd -> output directory

	print('\n\tSaving .csv file to "%s" ...') % saveDirectory
	writer = csv.writer(open(csvFileName, "w")) # create a new .csv file
	writer.writerows(selected) # save the selected rows

	conn.close() # close the .sqlite connection
	print('\n\tDone')

print('Done')
