{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      devShells.aarch64-darwin.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.protobuf
          (pkgs.lib.getDev pkgs.curl)
        ];

        buildInputs = [
          pkgs.curl
          pkgs.openssl
        ];

        env.OPENSSL_NO_VENDOR = 1;
      };
    };
}
