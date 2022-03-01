#!/usr/bin/env python3

import os
import glob

def processfile(file_path):
  lines_to_write = []
  with open(file_path, "r") as f:
    lines = f.readlines()
    for line in lines:
      if string_to_refactor in line:
        line = line.replace(string_to_refactor,  string)
        print(line)
      lines_to_write.append(line)
      
  with open(file_path, "w") as f:
    f.writelines(lines_to_write)

# docker --> local mode
# string_to_refactor = "/home/hoover/hoover/"
# string = "/home/marbas/uni/gbl/hoover/"

# local mode --> docker
# string = "/home/hoover/"
# string_to_refactor = "/home/marbas/uni/gbl/hoover/"

# change ips
string = "172.42.0.2"
string_to_refactor = "172.42.0.1" 

path = "lisa/"

for filename in glob.iglob(path + '**/*.py', recursive=True):
  processfile(filename)
  
