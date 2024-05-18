{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.flake-test-git = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      fs = pkgs.lib.fileset;
      fileSet = fs.unions [
        ./.
      ];
    in
      pkgs.stdenv.mkDerivation {
        pname = "flake-test-git";
        version = "1.0.0";
        src = fs.toSource {
          root = ./.;
          fileset = fileSet;
        };
        installPhase = ''
          mkdir -p $out/bin;
          cp bin/flake-test-git $out/bin;
        '';
        postInstall = ''
          mkdir -p $out/src
          cp -v * $out/src/
        '';

        # nativeBuildInputs = with pkgs; [
        #   cmake
        # ];
      };

    packages.x86_64-linux.default = self.packages.x86_64-linux.flake-test-git;
  };
}
