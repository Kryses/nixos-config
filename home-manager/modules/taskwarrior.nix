{ config, pkgs, lib, ...}:
{
 programs.taskwarrior3 = {
    enable = true;
    config = {
    };
    data.location = "~/.task";

    log = "on";
    log.file = "~/.local/share/task/task.log";
    hooks.location = "~/.config/task/hooks";
    default.project = "inbox";
    priority.default = "M";
    size.default = "M";
    recurrence.limit = "1";
    regex = "on";
    search.case.sensative = "no";
    active.indicator = "🕑";

    context.WK = "+work";
    context.HAB = "+habbit";
    context.HOME = "project:home or project:habbit";
    context.INBOX = "project:inbox";

    alias.punt = "modify wait:1d";
    alias.somday = "wait:somday";
    alias.work = "project:ENG +work";
    alias.unplanned-wk = "project:work +WK +unplanned due:tomorrow priority:H";
    alias.unplanned-hm = "project:home +hm +unplanned due:tomorrow priority:H";
    alias.unplanned-yt = "project:home +hm +youtube +unplanned due:tomorrow priority:H";
    alias.meeting = "project:work +WK +meeting due:tomorrow priority:H";
    alias.unplanned-meeting = "project:work +WK +unplanned +meeting due:tomorrow priority:H";
    alias.chore = "project:home +hm +next due:tomorrow priority:H";
    alias.sleep = "project:home +hm +sleep +next due:tomorrow priority:H";
    alias.home = "+hm or +hab";

    
    ## Inbox
    "report.in.columns" = "id,tags,description";
    "report.in.description" = "Inbox";
    "report.in.filter" = "project:inbox -WAITING status:pending limit:page ";
    "report.in.labels" = "ID,Tags,Description";

    ##Review
    "report._reviewed.description" = "Tasksh review report.  Adjust the filter to your needs.";
    "report._reviewed.columns" = "uuid";
    "report._reviewed.sort" = "reviewed+,modified+";
    "report._reviewed.filter" = "( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING ) ";


    ##Next
    "report.next.labels" = "Id,Description,Active,󰖡,󰘃,󰔹,Project,,󱑈,󱫌,due,,Reviewed";
    "report.next.columns" = "id,description.count,start.age,size,priority,pts,project,tags.count,scheduled.countdown,due.countdown,due,urgency,reviewed";

    ##sidebar
    "report.side.labels" = "Id,(P),Description,urg";
    "report.side.columns" = "id,priority,description,urgency";
    "report.side.sort" = "urgency-";
    "report.side.filter" = "(-COMPLETED -DELETED -WAITING) and limit:page";

    "urgency.user.tag.next.coefficient" = "15.0  +next tag";
    "urgency.due.coefficient" = "12.0 # overdue or near due date";
    "urgency.blocking.coefficient" = "8.0 # blocking other tasks";
    "urgency.uda.priority.F.coefficient" = "8.0 # fire Priority";
    "urgency.uda.priority.H.coefficient" = "6.0 # high Priority";
    "urgency.uda.priority.M.coefficient" = "3.9 # medium Priority";
    "urgency.uda.priority.L.coefficient" = "1.8 # low Priority";
    "urgency.scheduled.coefficient" = "5.0 # scheduled tasks";
    "urgency.active.coefficient" = "4.0 # already started tasks";
    "urgency.age.coefficient" = "2.0 # coefficient for age";
    "urgency.annotations.coefficient" = "1.0 # has annotations";
    "urgency.tags.coefficient" = "1.0 # has tags";
    "urgency.waiting.coefficient" = "-3.0 # waiting task";
    "urgency.blocked.coefficient" = "-15.0 # blocked by other tasks";
    #
    #Projects
    "urgency.user.project.home.lifeos.tasks.coefficient" = "2.0    ";
    "urgency.user.project.home.lifeos.coefficient" = "1.0    ";
    "urgency.user.project.HALAUNCH.coefficient" = "2.0    ";
    "urgency.user.project.HALONTOOLKIT.coefficient" = "1.0    ";

    #Goals
    ## Sort Term 1.0-1.5
    "urgency.user.tag.fast_developer.coefficient" = "1.5";
    "urgency.user.tag.load_payer.coefficient" = "1.5";
    "urgency.user.tag.halaunch_admin.coefficient" = "1.45";
    "urgency.user.tag.pipeline_director.coefficient" = "1.4";
    "urgency.user.tag.server_owner.coefficient" = "1.35";
    "urgency.user.tag.skilled_typist.coefficient" = "1.25";
    "urgency.user.tag.powerlifter.coefficient" = "1.24";
    "urgency.user.tag.mile_runner.coefficient" = "1.23";
    "urgency.user.tag.flow_master.coefficient" = "1.22";
    "urgency.user.tag.sociallite.coefficient" = "1.21";
    "urgency.user.tag.review.coefficient" = "-10.0";

    ## Long Term 0.5_1.0

    ### 5 years
    "urgency.user.tag.linux_guru.coefficient" = "1.0";
    "urgency.user.tag.game_maker.coefficient" = "1.0";
    "urgency.user.tag.guitar_player.coefficient" = "0.9";

    ### 10 years
    "urgency.user.tag.sketch_artist.coefficient" = "0.8";
    "urgency.user.tag.home_owner.coefficient" = "0.7";
    "urgency.user.tag.self_employed.coefficient" = "0.6";

    ## Dream 0.0_0.5

    "urgency.user.tag.master_developer.coefficient" = "0.5";
    "urgency.user.tag.task_master.coefficient" = "0.4";
    "urgency.user.tag.family_man.coefficient" = "0.3";
    "urgency.user.tag.tech_trailblazer.coefficient" = "0.2";


    #Tags
    "urgency.user.tag.DELEGATED.coefficient" = "-15.0    ";
    "urgency.user.tag.blocked.coefficient" = "-10.0    ";
    "urgency.user.tag.support.coefficient" = "1.0    ";
    "urgency.user.tag.review.coefficient" = "-10.0    ";
    "urgency.user.tag.blocked.coefficient" = "-10.0    ";
    "color.tag.blocked" = "red";
    "color.tag.review" = "blue";


    "uda.priority.values" = "F,H,M,L";

    "uda.size.type" = "string";
    "uda.size.label" = "Size 😅";
    "uda.size.default" = "S";

    #XXS: A minute
    #XS: 30mins
    #S: 1 hour
    #M  hours
    #L 1 Day
    #XL A few days
    #XXL A week
    "uda.size.values" = "XXS,XS,S,M,L,XL,XXL";
    "urgency.uda.size.XXS.coefficient" = "1.5";
    "urgency.uda.size.XS.coefficient" = "1.25";
    "urgency.uda.size.S.coefficient" = "1.0";
    "urgency.uda.size.M.coefficient" = "0.0";
    "urgency.uda.size.L.coefficient" = "-0.5";
    "urgency.uda.size.XL.coefficient" = "-2.0";
    "urgency.uda.size.XXL.coefficient" = "-4.0";

    "uda.pts.type" = "numeric";
    "uda.pts.label" = "Score 🏆";
    "uda.pts.default" = "1";

    "uda.reviewed.type" = "date";
    "uda.reviewed.label" = "Reviewed";

    "nag" = "You have more important tasks";
    "uda.jiraissuetype.type" = "string";
    "uda.jiraissuetype.label" = "Issue Type";
    "uda.jirasummary.type" = "string";
    "uda.jirasummary.label" = "Jira Summary";
    "uda.jiraurl.type" = "string";
    "uda.jiraurl.label" = "Jira URL";
    "uda.jiradescription.type" = "string";
    "uda.jiradescription.label" = "Jira Description";
    "uda.jiraid.type" = "string";
    "uda.jiraid.label" = "Jira Issue ID";
    "uda.jiraestimate.type" = "numeric";
    "uda.jiraestimate.label" = "Estimate";
    "uda.jirafixversion.type" = "string";
    "uda.jirafixversion.label" = "Fix Version";
    "uda.jiracreatedts.type" = "date";
    "uda.jiracreatedts.label" = "Created At";
    "uda.jirastatus.type" = "string";
    "uda.jirastatus.label" = "Jira Status";
    "uda.jirasubtasks.type" = "string";
    "uda.jirasubtasks.label" = "Jira Subtasks";

    #"taskd.ca" = "\/home\/kryses\/.task\/ca.cert.pem";
    "taskd.editor" = "nvim";
    "sync.server.origin" = "http:\/\/192.168.1.234:8080";
    "sync.server.client_id" = "ea68034d-ac3a-4249-aed0-1f82e41cb493";
    "recurrence" = "off";
    "sync.encryption_secret" = "c79ef59f-b687-4cee-8a21-c2f2c99f9d75";

  };
}
