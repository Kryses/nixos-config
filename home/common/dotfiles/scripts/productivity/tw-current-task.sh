#!/bin/zsh

current_task=$(timew | awk -F '"' '{print $2}')
echo $current_task

