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

      urgency = {
        user = {
          tag = {
            blocked.coefficient = -1;
            halon.coefficient = 0.75;
            home.coefficient = 0.0;
            home.safety.coefficient = 1.0;
            waiting.coefficient = -10.0;
          };
          project = {
            ai_server_build.coefficient = 0.75;
            proxmox_server_build.coefficient = 0.65;
            desktop_computer_build.coefficient = 0.5;
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
          labels = "ID,Tags,Description";
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
          filter = "( +PENDING or +WAITING ) -UNTIL -DELETED -BLOCKED -waiting";
        };
        waiting = {
          labels = "Id,Description,Active,󰖡,󰘃,Project,,󱑈,󱫌,due,,Reviewed";
          columns = "id,description.count,start.age,size,priority,project,tags.count,scheduled.countdown,due.countdown,due,urgency,reviewed";
          sort = "urgency-";
          filter = "-DELETED +waiting";
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
