#### querySql.py -- script for converting clock-synchronization data (between Plexon and Picto)
#### from .sqlite database form -> .csv form. MATLAB scripts take the .csv clock times as inputs
#### when looking at LFP data.

import sqlite3
import os
import csv
import glob # for getting directory items

didComplete = 0
include_align_code = 1 # if wanting the third column to be an align code (usually, you *do* want this)

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
	dataDirectory = raw_input('\nEnter name of the directory that houses your .sqlite files, or the umbrella directory that houses subfolders with .sqlite files> ')
	saveDirectory = raw_input('\nEnter the name of the directory in which to save .csv files, or input: same to use the .sqlite directory> ')

useSubfolders = raw_input('\n Specify whether to look within subfolders of the data directory> ')

os.chdir(dataDirectory)

if useSubfolders == '1':
	subfolders = glob.glob('*/')
	for d in range(len(subfolders)):
		subfolders[d] = os.path.join(dataDirectory,subfolders[d])
else:
	subfolders = dataDirectory

for e in range(len(subfolders)):
	fullFolderPath = subfolders[e] # get the full path to the subfolder
	print('\nProcessing Files in %s (%d of %d)') % (fullFolderPath,e+1,len(subfolders))

	os.chdir(fullFolderPath) # cd -> subfolder

	fileNames = glob.glob('*.sqlite') # get all the database files in the current folder

	if fileNames:

		for l in range(len(fileNames)): # for each database file ...
			print('\n\tProcessing File %d of %d') % (l+1,len(fileNames))
			fullFile = os.path.join(fullFolderPath,fileNames[l]) # get full patch to file

			print('\n\t\tLoading database file ...')
			conn = sqlite3.connect(fullFile) # load the file
			c = conn.cursor() # prep the file for querying

			print('\n\t\tAttempting to query database ...')

			if include_align_code == 0:
				query = 'SELECT neuraltime,behavioralTime FROM alignevents;'
			else:
				query = 'SELECT neuraltime,behavioralTime,aligncode FROM alignevents;'
				
			selected = c.execute(query) # get the neural time and behavioral time columns
			csvFileName = '%s.csv' % fileNames[l] # prep for a new .csv file

			if saveDirectory != 'same':
				os.chdir(saveDirectory) # cd -> specified save directory
			else:
				saveDirectory = fullFolderPath

			print('\n\t\tSaving .csv file to "%s" ...') % saveDirectory
			writer = csv.writer(open(csvFileName, "w")) # create a new .csv file
			writer.writerows(selected) # save the selected rows

			conn.close() # close the .sqlite connection
			print('\n\t\tDone')

	else:
			
		print('No .sqlite files were found in the folder %s, and it will be skipped') % fullFolderPath

	print('Done')
