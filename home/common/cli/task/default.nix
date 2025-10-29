{pkgs, ...}:
{
  home.packages = [
    pkgs.taskwarrior-tui
    pkgs.tasksh
  ];
  programs.taskwarrior = {
    enable = true;
    config = {
      data.location = "~/.task";
      hooks.location = ./hooks;
      default.project = "inbox";
      priority.default = "M";
      size.default = "M";
      sync.server.client_id = "ea68034d-ac3a-4249-aed0-1f82e41cb493";
      taskd = {
        editor = "nvim";
        server = "192.168.1.234:8080";
      };
      recurrence.limit = 1;
      regex = "on";
      journal.time = "one";
      search.case.sensative = "no";
      active.indicator = "🕑";

      context.work = "+work";
      context.home = "+home";
      context.inbox = "project:inbox";

      alias.punt = "modify wait:1d";
      alias.someday = "wait:someday";
      alias.work = "+halon";
      alias.tracked = "+jira";
      alias.home = "+home";

      alias.p = "project";
      alias.pr = "priority";
      alias.s = "size";

      urgency = {
        user = {
          tag = {
            blocked.coefficient = -1;
            halon.coefficient = 0.75;
            home.coefficient = 0.0;
            computer.coefficient = 0.1;
            safety.coefficient = 1.0;
            cleaning.coefficient = 2.0;
            support.coefficient = 0.75;
            waiting.coefficient = -10.0;
            family.coefficient = 0.75;
            personal.coefficient = 0.1;
            meeting.coefficient = 1.0;
          };
          project = {
            ai_server.coefficient = 0.75;
            proxmox_server.coefficient = 0.65;
            desktop_computer.coefficient = 0.5;
          };
        };
      };
      uda = {
        reviewed = {
          type = "date";
          label = "Reviewed";
        };
        priority = {
          values = "F,H,M,L";
          F.coefficient = 10.0;
        };
        size = {
          values = "XXS,XS,S,M,L,XL,XXL";
          type = "string";
          label = "Size 😅";
          default = "S";
          XXS = {
            coefficient = 0.75;
          };
          XS = {
            coefficient = 0.5;
          };
          S = {
            coefficient = 0.25;
          };
          M = {
            coefficient = 0.0;
          };
          L = {
            coefficient = -0.25;
          };
          XL = {
            coefficient = -0.5;
          };
          XXL = {
            coefficient = -0.75;
          };
        };
      };

      color = {
        tag = {
          blocked = "red";
          review = "blue";
        };
      };

      report = {
        inbox = {
          columns = "id,tags,description";
          description = "Inbox";
          filter = "project:inbox -WAITING status:pending limit:page";
          labels = "ID,Tags,Descripation";
        };
        _reviewed = {
          description = "Tasksh review report.  Adjust the filter to your needs.";
          columns = "uuid";
          sort = "reviewed+,modified+";
          filter = "( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING )";
        };
        next = {
          labels = "Id,Description,Active,󰖡,󰘃,Project,,󱑈,󱫌,due,,Reviewed";
          columns = "id,description.count,start.age,size,priority,project,tags.count,scheduled.countdown,due.countdown,due,urgency,reviewed";
          sort = "urgency-";
          filter = "( +PENDING ) -WAITING -DELETED -BLOCKED -waiting";
        };
        home = {
          labels = "Id,Description,Active,󰖡,󰘃,Project,,󱑈,󱫌,due,,Reviewed";
          columns = "id,description.count,start.age,size,priority,project,tags.count,scheduled.countdown,due.countdown,due,urgency,reviewed";
          sort = "urgency-";
          filter = "( +PENDING ) -WAITING -DELETED -BLOCKED -waiting +home";
        };
        work = {
          labels = "Id,Description,Active,󰖡,󰘃,Project,,󱑈,󱫌,due,,Reviewed";
          columns = "id,description.count,start.age,size,priority,project,tags.count,scheduled.countdown,due.countdown,due,urgency,reviewed";
          sort = "urgency-";
          filter = "( +PENDING ) -WAITING -DELETED -BLOCKED -waiting +halon";
        };
        waiting = {
          labels = "Id,Description,Active,󰖡,󰘃,Project,,󱑈,󱫌,due,,Reviewed";
          columns = "id,description.count,start.age,size,priority,project,tags.count,scheduled.countdown,due.countdown,due,urgency,reviewed";
          sort = "urgency-";
          filter = "-DELETED (+waiting or +WAITING)";
        };
        side = {
          labels = "Id,(P),Description,urg";
          columns = "id,priority,description,urgency";
          sort = "urgency-";
          filter = "(-COMPLETED -DELETED -WAITING) and limit:page";
        };
      };
    };
  };
}
