erl-python
==========

Requires erlport from erlport.org in order to work.

"bucket.sh n m" will launch the bucket_filler module in Erlang trying
to round-robin send m messages to n Python processes.

On most operating systems the number of processes will be limited by
the file handles, so on Un*x you have to do a
ulimit -Sn 250000
in order to be allowed to have many file handles.

You might also need more user processes
ulimit -Su 250000
but right now this has not been proven 100% to be a problem.

In order to set so high numbers the file
/etc/security/limits.conf
might have to be changed with things like
* soft nofile 250000
* hard nofile 250000
* soft nproc  250000
* hard nproc  250000

