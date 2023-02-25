{
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = { "application/json" = "helix.desktop"; };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "desk";
      documents = "doc";
      download = "dl";
      music = "music";
      pictures = "pic";
      publicShare = "pub";
      templates = "tpl";
      videos = "vid";
    };
  };
}
