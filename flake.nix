{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

        rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

        pre-commit = pkgs.callPackage ./nix/pre-commit.nix { inherit rust; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "zellij";

          packages = [
            rust
            pre-commit
            pkgs.pkg-config
            pkgs.protobuf
          ];

          buildInputs =
            [ pkgs.openssl ]
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
              pkgs.libiconv
              (pkgs.lib.getDev pkgs.curl)
              pkgs.curl
            ];

          env.OPENSSL_NO_VENDOR = 1;

          shellHook = ''
            if [ -d .git ]; then
              mkdir -p .git/hooks
              ln -sf ${pkgs.lib.getExe pre-commit} .git/hooks/pre-commit
            fi
          '';
        };
      }
    );
}
