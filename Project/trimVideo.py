# -*- coding: utf-8 -*-
"""
Created on Tue Nov 27 19:19:20 2018

@author: Jordan
"""

import os
from moviepy.editor import *
path = 'C:/Users/Jordan/Desktop/Cam_Net/'
destPath = 'C:/Users/Jordan/Desktop/Cam_Net_Clipped/'


files = os.listdir(path)
clipLength = 2

for file in files:
    fullClip = VideoFileClip(path + file)
    beg = input("Enter Start Clipping Time for " + file + ' :')
    clipStart = int(beg)
    clipped = fullClip.subclip(clipStart, clipStart + clipLength)
    clipped.write_videofile(destPath  + file)
    clipped.close()
