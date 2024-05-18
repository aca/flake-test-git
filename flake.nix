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
    # overlays.default = final: prev: {
    #   templ = self.packages.${final.stdenv.system}.flake-test-git;
    # };

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

        src = pkgs.fetchgit {
          # src = pkgs.fetchFromGitHub {
          # src = fetchgit {
          url = "https://github.com/aca/zapret.git";
          # rev = "main";
          sha256 = "sha256-sbwLK0nWUFstZ9RXqetSbBgW60wS5/0FLXM1VhublDk=";
        };
        # src = fs.toSource {
        #   root = ./.;
        #   fileset = fileSet;
        # };
        phases = ["installPhase" "postInstall"];
        installPhase = ''
          mkdir -p $out;
          cp -r $src $out/src;
          ls -al;
        '';
        postInstall = ''
          $out/src/install_bin.sh
        '';

        outputs = ["out"];

        propagatedBuildInputs = with pkgs; [
          curl
          iptables
          gawk
          procps
        ];
      };

    packages.x86_64-linux.default = self.packages.x86_64-linux.flake-test-git;
  };
}
