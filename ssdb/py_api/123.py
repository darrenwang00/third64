#!/usr/bin/env python
# -*- coding: utf-8 -*-
########################################################################
# 
# Copyright (c) 2016 Baidu.com, Inc. All Rights Reserved
# 
########################################################################
 
"""
File: aaa.py
Author: wangyan15(wangyan15@baidu.com)
Date: 2016/05/05 15:52:42
Brief: 
"""


import os, sys
from sys import stdin, stdout

from SSDB import SSDB
try:
	pass
	ssdb = SSDB('127.0.0.1', 8888)
except Exception , e:
	pass
	print e
	sys.exit(0)

def import_data():
    ID = 0
    for line in sys.stdin:
        ID += 1
        line = line.strip()
        ssdb.request('set', [str(ID), line])
        if ID % 10000 == 0:
            print ID



def search_data():
    for i in range(1, 500000):
        ssdb.request('get', [str(i)])
        if i % 10000 == 0:
            print i
    return True



if __name__ == "__main__":
    #import_data()
    search_data()




