{
  writeShellApplication,
  rust,
  pkg-config,
  protobuf,
  openssl,
}:

writeShellApplication {
  name = "zellij-pre-commit";
  runtimeInputs = [
    rust
    pkg-config
    protobuf
    openssl
  ];
  text = ''
    export OPENSSL_NO_VENDOR=1

    echo "pre-commit: cargo fmt --check"
    cargo fmt --check

    echo "pre-commit: cargo test -p zellij-utils"
    cargo test -p zellij-utils

    echo "pre-commit: cargo test -p zellij-server"
    cargo test -p zellij-server

    echo "pre-commit: cargo test -p zellij-client"
    cargo test -p zellij-client
  '';
}
