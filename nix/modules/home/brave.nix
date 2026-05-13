{ pkgs, lib, ... }:

let
  theme = import ../themes/monochrome.nix;
  bitwarden = pkgs.bitwarden-desktop;
  proxyPath = "${bitwarden}/libexec/desktop_proxy";

  bravePrefs = builtins.toJSON {
    brave = {
      darker_mode = true;
      brave_leo = {
        show_on_toolbar = false;
      };
      shields = {
        ads_trackers = "block";
        cookies = "block_third_party";
        fingerprinting = "block_third_party";
      };
      tabs = {
        vertical_tabs_enabled = true;
        vertical_tabs_collapsed = true;
        vertical_tabs_floating_enabled = false;
        vertical_tabs_hide_completely_when_collapsed = false;
        vertical_tabs_show_scrollbar = false;
        vertical_tabs_show_title_on_window = false;
      };
      sidebar = {
        sidebar_show_option = 3;
      };
      new_tab_page = {
        background = {
          random = false;
          selected_value = theme.colors.newTab;
          type = "color";
        };
        hide_all_widgets = true;
        show_background_image = false;
        show_branded_background_image = false;
        show_brave_news = false;
        show_clock = false;
        show_crypto_dot_com = false;
        show_ftx = false;
        show_rewards = false;
        show_stats = false;
        show_together = false;
        shows_options = 0;
      };
    };
    bookmark_bar = {
      show_on_all_tabs = false;
    };
    browser = {
      custom_chrome_frame = false;
      theme = {
        color_scheme2 = 0;
      };
    };
    search = {
      suggest_enabled = true;
    };
    autofill = {
      credit_card_enabled = false;
      profile_enabled = false;
    };
    credentials_enable_service = false;
  };

  prefsFile = pkgs.writeText "brave-prefs.json" bravePrefs;
  prefsPath = "$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences";
in

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;

    commandLineArgs = [
      "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,TouchpadOverscrollHistoryNavigation"
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
    ];
  };

  home.activation.bravePreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$(dirname "${prefsPath}")"
    if [ -f "${prefsPath}" ]; then
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "${prefsPath}" "${prefsFile}" > "${prefsPath}.tmp"
      mv "${prefsPath}.tmp" "${prefsPath}"
    else
      cp "${prefsFile}" "${prefsPath}"
    fi
  '';

  xdg.configFile."BraveSoftware/Brave-Browser/NativeMessagingHosts/com.8bit.bitwarden.json" = {
    force = true;
    text = builtins.toJSON {
      name = "com.8bit.bitwarden";
      description = "Bitwarden desktop <-> browser bridge";
      path = proxyPath;
      type = "stdio";
      allowed_origins = [
        "chrome-extension://nngceckbapebfimnlniiiahkandclblb/"
      ];
    };
  };
}
