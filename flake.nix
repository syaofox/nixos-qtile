# /mnt/github/nixos-qtile/flake.nix

{
  description = "NixOS configuration for nixos-dev with Qtile and Fcitx5";

  inputs = {
    # 核心 Nixpkgs (使用不稳定的最新分支以获取最新包)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager (使用最新稳定版本)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # 定义主机名为 "nixos-dev" 的系统配置
    nixosConfigurations."nixos-dev" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        # 引入系统级别配置
        ./configuration.nix

        # 引入 home-manager 模块
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # 指定用户 syaofox 的 home-manager 配置
          # Home Manager 会自动传递 config, pkgs 等参数
          home-manager.users.syaofox = ./home.nix;
        }
      ];
    };
  };
}

