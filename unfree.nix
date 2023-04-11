# Definitions can be imported from a separate file like this one

{ self, lib, ... }: {
  perSystem = { config, self', inputs', pkgs, system, ... }: {
    _module.args.pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
  flake = {
  };
}