#!/bin/zsh

twtime=$(timew | grep Total | awk '{print $2}')
echo $twtime
