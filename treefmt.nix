{
  projectRootFile = ".git/config";
  enableDefaultExcludes = true;

  settings.global.excludes = [
    "LICENSE"
    "*.age"
    "*.envrc"
  ];

  programs = {
    alejandra.enable = true;
    shfmt = {
      enable = true;
      indent_size = 2;
    };
    mdformat.enable = true;
  };
}
