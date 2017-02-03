#!/bin/bash
file_name=tmp_more_than_50
max_time=$(grep -o 'in \d*ms' $file_name  | sed -e 's/in\ //g' -e 's/ms//g' | sort -n | tail -n1)
grep -B1 $max_time $file_name | head -n1 | cut -d " " -f 3
