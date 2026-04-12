#!/run/current-system/sw/bin/nu

# Weekly summary: AI vs human task completions by project
let end_date = date now
let start_date = $end_date - 7day

let tasks = (task export | from json | where status == "completed" and ($it.end | into datetime) >= $start_date)

if ($tasks | is-empty) {
    print "No tasks completed in the last 7 days."
    exit
}

let start_str = $start_date | format date "%Y-%m-%d"
let end_str = $end_date | format date "%Y-%m-%d"

print $"Weekly Summary \(($start_str) → ($end_str)\)"
print ""

let by_project = $tasks | group-by { |t| $t.project? | default "none" }

let summary = $by_project | items { |project, tasks|
    let total = $tasks | length
    let ai = $tasks | where { |t|
        let tags = ($t.tags? | default [])
        let has_ai_tag = ("aicreated" in $tags) or ("aiqueue" in $tags)
        let has_agent = ($t.agent? | default "" | str length) > 0
        $has_ai_tag or $has_agent
    } | length
    let human = $total - $ai
    { project: $project, total: $total, ai: $ai, human: $human }
} | sort-by total --reverse

print "By Project:"
let max_name = $summary | each { |r| $r.project | str length } | math max
let max_total = $summary | each { |r| $r.total } | math max

$summary | each { |r|
    let bar = "" | fill --character "█" --width $r.total
    let pad = $r.project | fill --width ($max_name + 2) --alignment left
    print $"  ($pad) ($bar) ($r.total)  \(($r.ai) AI, ($r.human) human\)"
}

print ""
let grand_total = $summary | each { |r| $r.total } | math sum
let grand_ai = $summary | each { |r| $r.ai } | math sum
let grand_human = $summary | each { |r| $r.human } | math sum
print $"Totals: ($grand_total) completed \(($grand_ai) AI, ($grand_human) human\)"
