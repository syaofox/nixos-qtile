# /mnt/github/nixos-qtile/qtile/config.py

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile import hook
import subprocess
import os

mod = "mod4"  # Win/Super 键
terminal = "alacritty"

# ====================================================================
# Fcitx5 启动 Hook
# ====================================================================
@hook.subscribe.startup_once
def autostart():
    # 启动 Fcitx5 后台进程
    subprocess.Popen(["fcitx5", "-d"])

# ====================================================================
# 基础按键绑定
# ====================================================================

keys = [
    # 窗口操作
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "w", lazy.window.kill(), desc="Kill active window"),
    
    # 窗口移动
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    
    # 窗口调整大小
    Key([mod, "shift"], "h", lazy.layout.shrink_main(), desc="Shrink main window"),
    Key([mod, "shift"], "l", lazy.layout.grow_main(), desc="Grow main window"),
    
    # 布局切换
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    
    # Qtile 管理
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    
    # 输入法切换 (通常是 Ctrl+Space 或 Shift，这里用 Ctrl+Space 启动 fcitx5 切换命令)
    Key(["control"], "space", lazy.spawn("fcitx5-remote -t"), desc="Toggle Fcitx5"),
]

# ====================================================================
# Groups 和 Layouts
# ====================================================================

groups = [
    Group(i, label=f" {i}") for i in "123456789"
]

for i in groups:
    keys.extend(
        [
            Key([mod], i.name, lazy.group[i.name].toscreen(), 
                desc="Switch to group {}".format(i.name)),
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), 
                desc="Switch to & move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.MonadTall(
        border_focus='#88c0d0',
        border_normal='#4c566a',
        border_width=2,
        margin=10,
    ),
    layout.Max(),
]

# ====================================================================
# 鼠标操作
# ====================================================================

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# ====================================================================
# 浮动窗口规则
# ====================================================================

floating_layout = layout.Floating(
    border_focus='#88c0d0',
    border_normal='#4c566a',
    border_width=2,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)

# ====================================================================
# 状态栏 Widgets
# ====================================================================

widget_defaults = dict(
    # 使用中文字体确保状态栏正常显示中文、输入法状态等
    font="Noto Sans CJK SC", 
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(
                    disable_drag=True,
                    active='#88c0d0',
                    inactive='#4c566a',
                    this_current_screen_border='#88c0d0',
                    block_highlight_text_color='#2e3440',
                ),
                widget.Prompt(),
                widget.WindowName(),
                widget.Spacer(),
                # 托盘图标，用于显示 Fcitx5 的图标
                widget.Systray(), 
                widget.Clock(
                    format="%Y-%m-%d %a %H:%M",
                ),
                widget.QuickExit(),
            ],
            24, # Bar 高度
        ),
    ),
]

# ====================================================================
# 其他配置
# ====================================================================

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"

