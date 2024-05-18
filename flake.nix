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

    packages.x86_64-linux.hello-repeater = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      fs = pkgs.lib.fileset;
      fileSet = fs.unions [
        ./hello.sh
      ];
    in
      pkgs.stdenv.mkDerivation {
        pname = "hello-repeater";
        version = "1.0.0";
        src = fs.toSource {
          root = ./.;
          fileset = fileSet;
        };
        postInstall = ''
          mkdir $out
          cp -v hello.sh $out/bin
        '';

        nativeBuildInputs = with pkgs; [
          cmake
        ];
      };

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello-repeater;
  };
}
