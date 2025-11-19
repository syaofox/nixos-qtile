# /mnt/github/nixos-qtile/home.nix
{ config, pkgs, ... }:

{
  # 1. 用户基本信息
  home.username = "syaofox";
  home.homeDirectory = "/home/syaofox";
  
  # 2. Home Manager 状态版本
  home.stateVersion = "25.05"; 

  # 3. Fcitx5 输入法配置
  # 注意：fcitx5 已在系统级别配置（configuration.nix），环境变量已在 sessionCommands 中设置
  # Home Manager 不支持 services.fcitx5，因此通过环境变量和启动脚本处理
  # Fcitx5 会在 Qtile 启动时自动启动（见 qtile/config.py 中的 autostart hook）

  # 4. Qtile 配置
  # 注意：Qtile 已在系统级别启用（configuration.nix 中的 services.xserver.windowManager.qtile）
  # Home Manager 不支持 xsession.windowManager.qtile，因此只管理配置文件
  xsession.enable = true; # 启用 X session 管理（用于其他 X session 相关配置）

  # 5. Git 配置
  programs.git = {
    enable = true;
    userName = "syaofox";
    userEmail = "syaofox@gmail.com";
  };

  # 6. 用户安装的软件包
  # 注意：qtile 已在系统级别安装（configuration.nix），无需在此重复
  home.packages = with pkgs; [
    # Qtile 的 Python 依赖（如果 Qtile 配置需要）
    python3Packages.psutil
    
    # 版本控制工具（git 通过 programs.git 自动安装）
    git-lfs
    
    # 编辑器
    neovim
    vim
    
    # 终端模拟器、浏览器等应用
    alacritty
    firefox
  ];

  # 7. 链接 Qtile 配置文件
  # 假设您将 Qtile 的 Python 配置文件放在了 ./qtile/config.py
  xdg.configFile."qtile/config.py".source = ./qtile/config.py;

  # 8. 终端编码 (确保终端中文显示正常)
  home.sessionVariables = {
    LANG = "zh_CN.UTF-8";
  };
}

