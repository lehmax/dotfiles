{
  description = "Home Manager configuration";

  # Inputs are pinned to commits at least 7 days old as a supply-chain
  # cooldown: the `nix-update` shell function rewrites the revs below to the
  # newest nixpkgs-unstable / home-manager commits older than one week, so a
  # compromised upstream release has a week to be detected and yanked before it
  # can land here. Keep the `github:owner/repo/<rev>` shape so the rewrite works.
  #
  # Exception: `nixpkgs-fresh` floats on nixpkgs-unstable with no cooldown and
  # is only used for packages that release too often for a week-old pin to be
  # useful (see `freshPackages` below). `nix flake update` bumps it to HEAD.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/92559d34fc4ee5513c1be6029a8be7b76772ca70";
    nixpkgs-fresh.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/fae6e9e42c3b762ab47635cddcfaf6f52374a61b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-fresh, home-manager, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      username = (import ./user.nix).username;
      freshPackages = [ "claude-code" ];
      freshOverlay = system: final: prev:
        let
          fresh = import nixpkgs-fresh {
            inherit system;
            config.allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) freshPackages;
          };
        in
        nixpkgs.lib.genAttrs freshPackages (name: fresh.${name});
    in
    {
      homeConfigurations = builtins.listToAttrs (map (system: {
        name = "${username}@${system}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            { nixpkgs.overlays = [ (freshOverlay system) ]; }
          ];
          extraSpecialArgs = { inherit username; };
        };
      }) supportedSystems);
    };
}
