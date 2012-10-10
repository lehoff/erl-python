#!/usr/local/bin/bash
sysctl -w  kern.maxfiles=250000
sysctl -w kern.maxfilesperproc=200000
sysctl -w kern.maxproc=2048
sysctl -w kern.maxprocperuid=45000
