# /mnt/github/nixos-qtile/home.nix
{ config, pkgs, ... }:

{
  # 1. 用户基本信息
  home.username = "syaofox";
  home.homeDirectory = "/home/syaofox";
  
  # 2. Home Manager 状态版本
  home.stateVersion = "25.05"; 

  # 3. Fcitx5 输入法配置 (用户级启动)
  services.fcitx5 = {
    enable = true;
    # 确保在用户会话中设置输入法相关的环境变量
    imModule.enable = true; 
    
    extraConfig = {
      # 默认启动拼音输入法
      "Input Method" = "pinyin";
    };
  };

  # 4. Qtile 配置
  xsession.enable = true; # 启用 X session 管理
  
  services.qtile = {
    enable = true;
  };

  # 5. 用户安装的软件包 (包括 Qtile 及其依赖)
  home.packages = with pkgs; [
    qtile # 确保 Qtile 本身被安装
    python3Packages.psutil # Qtile 推荐的依赖（使用 python3Packages 以自动适配默认 Python 版本）
    
    # 终端模拟器、浏览器等应用
    alacritty
    firefox
  ];

  # 6. 链接 Qtile 配置文件
  # 假设您将 Qtile 的 Python 配置文件放在了 ./qtile/config.py
  xdg.configFile."qtile/config.py".source = ./qtile/config.py;

  # 7. 终端编码 (确保终端中文显示正常)
  home.sessionVariables = {
    LANG = "zh_CN.UTF-8";
  };
}

