{
  description = "A website backend I'm making - no clue what for yet though.";
  inputs = {
    pkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    naersk.url = "github:nmattia/naersk";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, pkgs, unstable, naersk, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgsLegacyPackages = pkgs.legacyPackages."${system}";
        unstableLegacyPackages = unstable.legacyPackages."${system}";
        compileDeps =
          [ unstableLegacyPackages.cargo unstableLegacyPackages.rustc ];
        runtimeDeps =
          [ pkgsLegacyPackages.openssl pkgsLegacyPackages.pkg-config ];
        RUST_SRC_PATH =
          "${unstableLegacyPackages.rust.packages.stable.rustPlatform.rustLibSrc}";
      in {
        defaultPackage = naersk.lib."${system}".buildPackage {
          pname = "website-backend";
          root = ./.;
          buildInputs = compileDeps;
          nativeBuildInputs = runtimeDeps;
        };

        devShell = pkgsLegacyPackages.mkShell {
          nativeBuildInputs = compileDeps
            ++ [ pkgsLegacyPackages.rust-analyzer pkgsLegacyPackages.rustfmt ];
          buildInputs = runtimeDeps;
          inherit RUST_SRC_PATH;
        };
      });
}
