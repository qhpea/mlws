{
  description = "mlws";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
        # ./unfree.nix
        # flake-parts.flakeModules.unfree
      ];
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        
        # set allowUnfree
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
          # 3080 is 8.6
          # 4090 is 8.9; sm_89 virt target compute_89
          cudaCapabilities = [ "8.6" ];
          # cudaVersion = "12.1";
        };
        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;

        devenv.shells.default = {
          name = "mlws";
          languages.python.enable = true;
          # python 311 has big performance improvements
          # languages.python.package = pkgs.python311;
          languages.python.poetry.enable = true;
          
          # need rust quite a bit
          languages.rust.enable = true;
          
          # https://devenv.sh/reference/options/
          packages = with pkgs; [ cudatoolkit stdenv.cc.cc.lib ];

          # enterShell = ''
          #   hello
          # '';
#            shellHook = ''
#    export CUDA_PATH=${pkgs.cudatoolkit}
#    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath (with pkgs; [
#      linuxPackages.nvidia_x11
#      cudatoolkit
#      cudatoolkit.out
#      cudaPackages.cudnn_8_5_0
#    ])}"
#  '';
        };

      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
