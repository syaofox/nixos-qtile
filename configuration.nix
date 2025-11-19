# /mnt/github/nixos-qtile/configuration.nix
{ config, pkgs, ... }:

{
  # 0. 启用 Nix Flakes 功能
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 1. 主机名与用户
  networking.hostName = "nixos-dev";

  users.users.syaofox = {
    isNormalUser = true;
    description = "Syaofox";
    # 确保用户在必要的群组中
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ]; 
  };

  # 2. 中文环境与字体（完美中文显示）
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk      # 推荐的思源字体系列
    wqy_zenhei          # 文泉驿正黑
    dejavu_fonts        # 常用西文字体
  ];

  # 3. Fcitx5 输入法框架 (系统级启用)
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs.fcitx5-addons; [
      pinyin            # 拼音输入法引擎
      fcitx5-gtk        # GTK 应用的输入法支持
      fcitx5-qt         # Qt 应用的输入法支持
    ];
  };

  # 4. 桌面与窗口管理器 (Qtile)
  services.xserver = {
    enable = true;
    xkb.layout = "us"; # 键盘布局

    # 推荐使用 LightDM 作为登录管理器
    displayManager = {
      lightdm.enable = true;
      # 确保 X session 能够识别 Fcitx5 环境变量
      sessionCommands = ''
        export GTK_IM_MODULE=fcitx
        export QT_IM_MODULE=fcitx
        export XMODIFIERS=@im=fcitx
      '';
    };
  };

  # 5. 系统状态版本
  system.stateVersion = "25.05"; # 使用最新版本
}

