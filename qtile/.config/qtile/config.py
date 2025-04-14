from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import subprocess
import os
import logging
from libqtile import bar, layout, qtile, widget, hook

logging.basicConfig(level=logging.DEBUG)

mod = "mod4"
alt = "mod1"
terminal = "wezterm"
browser = "~/./Min-1.35.0-beta.AppImage --enable-accelerated-video-decode --enable-accelerated-video-encode"
browser1 = "google-chrome-stable --enable-accelerated-video-decode --enable-accelerated-video-encode"
code_editor = "cursor.AppImage"
github_desktop = "github-desktop"
spotify = "spotify"
discord = "discord"
obsidian = "obsidian.AppImage"


@hook.subscribe.startup
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([home])


keys = [
    Key([alt], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([alt], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([alt], "j", lazy.layout.down(), desc="Move focus down"),
    Key([alt], "k", lazy.layout.up(), desc="Move focus up"),
    Key([alt], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key(
        [mod, "control"],
        "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "shift"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "shift"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
    Key([mod, "shift"], "b", lazy.spawn(browser1), desc="Launch secondary browser"),
    Key([mod], "u", lazy.spawn(code_editor), desc="Launch editor"),
    Key([mod], "g", lazy.spawn(github_desktop), desc="Launch github_desktop"),
    Key([mod], "s", lazy.spawn(spotify), desc="Launch spotify"),
    Key([mod], "o", lazy.spawn(obsidian), desc="Launch obsidian"),
    Key([mod], "i", lazy.spawn(discord), desc="Launch discord"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "space", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Volume Control
    Key(
        [],
        "F3",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="Increase volume",
    ),
    Key(
        [],
        "F2",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="Decrease volume",
    ),
    Key(
        [],
        "F1",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Toggle mute",
    ),
    # Brightness Control
    Key([], "F5", lazy.spawn("brightnessctl set 5%-"), desc="Decrease brightness"),
    Key([], "F6", lazy.spawn("brightnessctl set +5%"), desc="Increase brightness"),
]

for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [
    Group(i) for i in ["  ", "  ", "  ", "  ", "  ", " 󰡈 ", "  ", "  ", "  "]
]
groups_hotkeys = "123456789"

for g, k in zip(groups, groups_hotkeys):
    keys.extend(
        [
            Key(
                [mod],
                k,
                lazy.group[g.name].toscreen(),
                desc=f"Switch to group {g.name}",
            ),
            Key(
                [mod, "shift"],
                k,
                lazy.window.togroup(g.name, switch_group=False),
                desc=f"Switch to & move focused window to group {g.name}",
            ),
        ]
    )

# Colors
dracula = {
    "rosewater": "#f5e0dc",
    "flamingo": "#f2cdcd",
    "pink": "#f5c2e7",
    "mauve": "#cba6f7",
    "red": "#f38ba8",
    "maroon": "#eba0ac",
    "peach": "#fab387",
    "yellow": "#f9e2af",
    "green": "#a6e3a1",
    "teal": "#94e2d5",
    "sky": "#89dceb",
    "white": "#d9e0ee",
    "grey": "#6e6c7e",
    "black": "#1a1826",
}

layouts = [
    layout.MonadTall(
        margin=5,
        border_width=2,
    ),
    layout.Tile(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=16,
    padding=2,
    foreground=dracula["black"],
)
extension_defaults = widget_defaults.copy()


def get_brightness():
    # Get current brightness percentage
    brightness = (
        subprocess.check_output(
            "brightnessctl g | awk '{print int($1/255*100)}'", shell=True
        )
        .decode()
        .strip()
    )
    return f"☀️ {brightness}%"


def get_widgets(primary=False):
    widgets = [
        widget.Spacer(length=2, background="#00000000"),  # Spacer at the start
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["black"],
            background="#00000000",
        ),
        widget.GroupBox(
            highlight_method="line",
            background=dracula["black"],
            highlight_color=[dracula["green"], dracula["green"]],
            inactive=dracula["grey"],
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["black"],
            background="#00000000",
        ),
        widget.Prompt(
            fontsize=18,
            padding=20,
            foreground=dracula["rosewater"],
        ),
        widget.Spacer(length=10, background="#00000000"),  # Spacer after GroupBox
        widget.WindowName(
            fontsize=18,
            padding=20,
            foreground=dracula["white"],
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["sky"],
            background="#00000000",
        ),
        widget.Volume(
            fmt="󰖀 {}",
            mute_command="pactl set-sink-mute @DEFAULT_SINK@ toggle",
            volume_command="pactl list sinks | grep 'Volume:' | head -n 1 | awk '{print $5}'",  # Get current volume
            foreground=dracula["black"],
            background=dracula["sky"],
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["sky"],
            background="#00000000",
        ),
        widget.Spacer(length=40, background="#00000000"),  # Spacer after WindowName
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["green"],
            background="#00000000",
        ),
        widget.TextBox(
            text=get_brightness(),
            foreground=dracula["black"],
            background=dracula["green"],
            update_interval=1,
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["green"],
            background="#00000000",
        ),
        widget.Spacer(length=40, background="#00000000"),  # Spacer after Brightness
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["peach"],
            background="#00000000",
        ),
        widget.CPU(
            format="󰻠 {load_percent:04}%",
            foreground=dracula["black"],
            background=dracula["peach"],
            update_interval=1,  # Update every second
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["peach"],
            background="#00000000",
        ),
        widget.Spacer(length=40, background="#00000000"),  # Spacer after CPU
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["maroon"],
            background="#00000000",
        ),
        widget.Clock(
            format="󰥔  %I:%M: %p",
            foreground=dracula["black"],
            background=dracula["maroon"],
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["maroon"],
            background="#00000000",
        ),
        widget.Spacer(length=40, background="#00000000"),  # Spacer after Clock
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["peach"],
            background="#00000000",
        ),
        widget.Battery(
            format="🔋 {percent:2.0%} {status}",
            foreground=dracula["black"],
            background=dracula["peach"],
            update_interval=60,
            charge_char="⚡",
            discharge_char="⚡",
            full_char="🔋",
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["peach"],
            background="#00000000",
        ),
        widget.Spacer(length=40, background="#00000000"),  # Spacer after Clock
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["grey"],
            background="#00000000",
        ),
        widget.Systray(
            foreground=dracula["black"],
            background=dracula["grey"],
        ),
        widget.TextBox(
            text="",
            padding=0,
            fontsize=30,
            foreground=dracula["grey"],
            background="#00000000",
        ),
    ]

    if primary:
        return widgets


screens = [
    Screen(
        top=bar.Bar(
            get_widgets(primary=True),
            22,
            margin=2,
            background="#00000000",
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 30

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
