{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
          # 3080 is 8.6
          # 4090 is 8.9; sm_89 virt target compute_89
          cudaCapabilities = [ "8.6" ];
          # cudaVersion = "12.1";
        };
        poetry2nix' = import poetry2nix {
          inherit pkgs;
          # packages.poetry = pkgs.poetry;
        };
        customOverrides = self: super: { };

        my_env = poetry2nix'.mkPoetryEnv {
          projectDir = ./.;
          preferWheels = true;
          overrides = [ poetry2nix'.defaultPoetryOverrides customOverrides ];
          python = pkgs.python310;
        };
      in
      {
        packages = {
          myapp = poetry2nix'.mkPoetryApplication { projectDir = self; };
          default = self.packages.${system}.myapp;
        };

        # devShells.default = pkgs.mkShell {
        #   packages = [ poetry2nix.packages.${system}.poetry ];
        # };
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ poetry my_env ]; };
      });
}
