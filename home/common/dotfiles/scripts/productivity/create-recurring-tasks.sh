#!/usr/bin/zsh

tasks=(
    "project:habbit 'make bed' size:L priority:H due:10am recur:daily wait:due-1hr +habit"
    "project:habbit 'brush teeth' size:L priority:H due:10am recur:daily wait:due-1hr +habit"
    "project:habbit 'walk' size:L priority:H due:10am recur:daily wait:due-1hr +habit"
    "project:habbit 'feed rabbits' size:L priority:H due:10am recur:daily wait:due-1hr +habit"
    "project:habbit 'shower' size:L priority:H due:10am recur:daily wait:due-1hr +habit"
    "project:habbit 'make dinner' size:L priority:H due:11pm recur:daily wait:due-1hr +habit"
    "project:habbit 'brush teeth' size:L priority:H due:11pm recur:daily wait:due-1hr +habit"
    "project:habbit 'feed rabbits' size:L priority:H due:11pm recur:daily wait:due-1hr +habit"
    "project:habbit 'journal' size:L priority:H due:11pm recur:daily wait:due-1hr +habit"
    "project:habbit 'sleep' size:L priority:H due:11pm recur:daily wait:10pm +habit +sleep"
    "project:habbit 'vacuum room' size:L priority:H due:11pm recur:3days wait:due-1hr +habit"
    "project:habbit 'clean rabbit cage' size:L priority:H due:11pm recur:3days wait:due-1hr +habit"
)
echo "${tasks[@]}"


task delete status:recurring 

echo "Creating recurring tasks..."
for task in "${tasks[@]}"; do
    echo "Adding task: $task"
    eval "task add $task"
done

