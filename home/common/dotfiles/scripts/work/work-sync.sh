#!/run/current-system/sw/bin/bash

while inotifywait -r --exclude '\.git/|\.kryses/|\.mypy_cache|__pycache__/' -e modify -e create -e move ./ayon-workspace; do
  rsync -azvu --delete --exclude '**/package/**' --exclude '.venv' --exclude '.mypy_cache' --exclude '.git' --exclude '.kryses' --exclude '.github' --exclude '*.pyc' \
    --exclude '**/__pycache__/**' ./ayon-workspace kryses@10.205.42.100:/mnt/e/development
done
