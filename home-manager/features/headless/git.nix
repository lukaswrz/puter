{ pkgs, ... }: {
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "brightyellow ul ol";
          file-style = "bold yellow ul";
          hunk-header-decoration-style = "purple box";
          hunk-header-style = "file line-number syntax";
        };
        features = "line-numbers decorations";
        whitespace-error-style = "22 reverse";
      };
    };
    package = pkgs.gitAndTools.gitFull;
    userName = "Lukas Wurzinger";
    userEmail = "lukas@wrz.one";
    extraConfig = {
      feature.manyFiles = true;
      init.defaultBranch = "main";
      color.ui = true;
    };
    lfs = { enable = true; };
    ignores = [
      ".idea/"
      ".vscode/"
      ".iml"
      "*.sublime-workspace"

      "node_modules/"
      "vendor/"

      "log/"
      "*.log"

      "__pycache__/"
      "zig-cache/"

      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      "*.pyc"
      "*.pyo"

      "*.7z"
      "*.dmg"
      "*.gz"
      "*.iso"
      "*.jar"
      "*.rar"
      "*.tar"
      "*.zip"
      "*.msi"

      "*.sqlite"
      "*.sqlite3"
      "*.db"
      "*.db3"
      "*.s3db"
      "*.sl3"
      "*.rdb"

      "*.bak"
      "*.swp"
      "*.swo"
      "*~"
      "*#"

      "zig-out/"
    ];
    # signing = {
    #   signByDefault = true;
    #   key = "";
    # };
  };
}
