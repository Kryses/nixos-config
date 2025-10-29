#!/run/current-system/sw/bin/nu

for $x in (task project:ai_server_build +PENDING export | from json | select id) {if $.id != 0 {tm $x.id project:ai_server}
