let
  drv = import ./default.nix {};
in
  {
    my_project = drv.shell;
    name = "site";
    buildInputs = [];
    shellHook = ''
      npm install
    '';
  }
