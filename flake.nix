{
  description = "A very basic flake";
  inputs.pkgs_url.url = "github:NixOS/nixpkgs/nixos-20.09";

  outputs = { self, pkgs_url }:
    let pkgs = import pkgs_url {system="x86_64-linux";};
    in
  {
    devShell."x86_64-linux" = pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.cargo
        pkgs.rustc
        pkgs.rustfmt
        pkgs.openssl
        pkgs.pkg-config
      ];
      buildInputs = [ pkgs.rust-analyzer ];
    };
  };
}
