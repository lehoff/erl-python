#!/usr/local/bin/bash
sysctl -w kern.maxfiles=12288
sysctl -w kern.maxfilesperproc=10240
sysctl -w kern.maxproc=1064
sysctl -w kern.maxprocperuid=709
