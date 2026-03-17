while (true) {
  play ~/scripts/mixkit-gaming-lock-2848.wav;
  notify-send "Focused Work";
  termdown "15m" --title "Focused Work";       


  notify-send "Shift Focus Break";
  play ~/scripts/mixkit-gaming-lock-2848.wav;
  termdown "20s" --title "Focus on Something Else";


  notify-send "Move Break";
  play ~/scripts/mixkit-gaming-lock-2848.wav;
  termdown "20s" --title "Move";       

  notify-send "Plan Next Move";
  play ~/scripts/mixkit-gaming-lock-2848.wav;
  termdown "2m" --title "Plan Next Move";       
}
