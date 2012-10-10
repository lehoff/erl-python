#!/usr/local/bin/bash
erl -env ERL_MAX_PORTS 200500 +P 1000000 -noshell -run bucket_filler fill $1 $2 -s init stop
