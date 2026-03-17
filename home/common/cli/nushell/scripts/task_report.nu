#!/run/current-system/sw/bin/nu
let work_start = "09:00" | into datetime
let work_end = "17:00" | into datetime

let current_time = date now
let current_day = date now | format date "%A"

if ($current_day != "Saturday") or ($current_day != "Sunday") {
    if ($current_time >= $work_start and $current_time <= $work_end) {
        task work
    } else if ((($current_time >= ("00:00" | into datetime)) and ($current_time <= $work_start)) or (($current_time <= ("23:59" | into datetime)) and ($current_time >= $work_end))) {
        task home
    }
} else {
    task home
}
