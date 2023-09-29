{
  programs.nushell = {
    enable = true;

    configFile.source = ./config.nu;

    environmentVariables = {
      # FIXME: Not properly serialized
      PROMPT_COMMAND_RIGHT = "''";
    };

    shellAliases = {
      l = "ls";
      lsa = "ls -a";
      la = "ls -a";
      lsl = "ls -l";
      ll = "ls -l";
      lsla = "ls -la";
      lla = "ls -la";
      cpr = "cp -r";
      rmr = "rm -r";
      rr = "rm -r";
      gi = "git";
      gic = "git commit";
      gico = "git checkout";
      gis = "git status";
      gid = "git diff";
      gidh = "git diff HEAD";
      gia = "git add";
      s = "sudo";
      g = "grep";
      gn = "grep -n";
      gin = "grep -in";
      grin = "grep -rin";
      df = "df -h";
      du = "du -h";
      c = "cd";
      "cd." = "cd .";
      "cd.." = "cd ..";
      ffmpeg = "ffmpeg -hide_banner";
      ffprobe = "ffprobe -hide_banner";
      ffplay = "ffplay -hide_banner";
    };
  };
}
