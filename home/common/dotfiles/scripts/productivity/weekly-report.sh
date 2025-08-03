#!/usr/bin/zsh
echo '## Burndown'
echo '___'

echo '```text'
task burndown.daily 
echo '```'
echo ''
echo '___'

toilet -f big 'Tasks'
echo '___'
echo '```text'
echo '___'
task rc.report.completed.columns=project,description.count,end \
  rc.report.completed.labels=project,description,end \
  completed end.after:$(date -d 'last week' +'%Y-%m-%dT00:00:00') end.before:$(date +'%Y-%m-%dT00:00:00')
echo '```'


