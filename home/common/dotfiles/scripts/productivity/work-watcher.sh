#!/bin/zsh
#

while inotifywait -r -e modify ~/repos/work/pipeline-workspace; do
    rsync -e "ssh -p 2222" -rvaz --update --exclude='.git' ~/repos/work/pipeline-workspace $(pass work/hl/hal-ssh-ip):/mnt/e/development
done
