{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }: flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs { inherit system overlays; };
    in
    {
      devShells.haskell = pkgs.mkShell {
        buildInputs = with pkgs; [
          haskell.compiler.ghc9122
          cabal-install
          (haskell-language-server.override {
            supportedGhcVersions = [ "912" ];
          })
          hlint
          haskellPackages.ghci-dap
          haskellPackages.haskell-debug-adapter
        ];
      };

      devShells.rust = pkgs.mkShell {
        buildInputs = with pkgs; [
          (rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" ];
          })
          clippy
          pkg-config
          bacon

          lldb
        ];
      };
    }
  );
}
