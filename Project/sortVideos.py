# -*- coding: utf-8 -*-
"""
Created on Tue Nov 27 17:29:00 2018

@author: Jordan
"""

import os, path
# Find and sort the videos as a function of time
paths = ['C:/Users/Jordan/Desktop/Cam_Net/', 'C:/Users/Jordan/Desktop/Cam_Side/']
times = []

videoFiles = {}

for path in paths:
    shotCounter = 0
    files = os.listdir(path)
    videoFiles[path] = {}

    for video in files:
        videoFiles[path][video] = {}
        time = os.path.getctime(path+video)
        videoFiles[path][video]['time'] = time
        videoFiles[path][video]['newName'] = ''
        times.append(time)

    # Sort the time stamps and rename files
    list.sort(times)
    for time in times:
        for videoName, timeInstance in videoFiles[path].items():
            if(time == timeInstance['time']):
                videoFiles[path][videoName]['newName'] = 'Shot_' + str(shotCounter) +'.MP4'
                shotCounter += 1

    for video in videoFiles[path].keys():
        oldName = path + video
        newName = path + videoFiles[path][video]['newName']
        os.rename(oldName, newName)

path = 'C:/Users/Jordan/Desktop/Cam_Top/'
files = os.listdir(path)
shotCounter = 0
fileNumbers = []
for file in files:
    fileNumbers.append(int(file[5:8]))
list.sort(fileNumbers)

for number in fileNumbers:
    newName = path + 'Shot_' + str(shotCounter) +'.MP4'
    shotCounter +=1
    oldName = path + 'GOPR0' + str(number) + '.MP4'
    os.rename(oldName, newName)
