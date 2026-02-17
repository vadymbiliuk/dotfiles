{ config, pkgs, lib, ... }:

let
  baseSettings = {
    "browser.profileManager.enabled" = true;
    "sidebar.visibility" = "always-show";
    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;

    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;

    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    "browser.cache.disk.enable" = true;
    "browser.cache.memory.enable" = true;
    "browser.sessionhistory.max_total_viewers" = 4;

    "browser.toolbars.bookmarks.visibility" = "newtab";
    "browser.tabs.warnOnClose" = false;
    
    "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","adguardadblocker_adguard_com-browser-action","_react-devtools-browser-action","extension_redux_devtools-browser-action","_e6fc2bbd-183e-4518-9ea5-04a8a913ab00_-browser-action","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","adguardadblocker_adguard_com-browser-action","_react-devtools-browser-action","extension_redux_devtools-browser-action","_e6fc2bbd-183e-4518-9ea5-04a8a913ab00_-browser-action"],"dirtyAreaCache":["nav-bar","toolbar-menubar","TabsToolbar","PersonalToolbar"],"currentVersion":20,"newElementCount":0}'';
    "browser.tabs.inTitlebar" = 1;

    "browser.urlbar.suggest.searches" = true;
    "browser.search.suggest.enabled" = true;
    
    "ui.key.menuAccessKeyFocuses" = false;
    
    "browser.formfill.enable" = false;
    "signon.rememberSignons" = false;
    "signon.autofillForms" = false;
  };

  baseSearch = {
    force = true;
    default = "ddg";
    privateDefault = "ddg";
    engines = {
      "google".metaData.hidden = true;
      "amazondotcom-us".metaData.hidden = true;
      "bing".metaData.hidden = true;
      "ebay".metaData.hidden = true;
      "wikipedia".metaData.alias = "@wiki";
    };
  };
in {
  programs.firefox = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.firefox else null;

    policies = {
      DisplayBookmarksToolbar = "newtab";
      SearchEngines = {
        Default = "DuckDuckGo";
        Remove = [ "Google" "Bing" "Amazon.com" "eBay" ];
      };
      Extensions = {
        Locked = [
          "{446900e4-71c2-419f-a6a7-df9c091e268b}"
          "addon@darkreader.org"
          "@react-devtools"
          "extension@redux.devtools"
          "adguardadblocker@adguard.com"
          "{e6fc2bbd-183e-4518-9ea5-04a8a913ab00}"
          "{41bb7295-c2bd-4e13-885f-dc67cb983c17}"
        ];
      };
      ExtensionSettings = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "@react-devtools" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/react-devtools/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "extension@redux.devtools" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/reduxdevtools/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "adguardadblocker@adguard.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "{e6fc2bbd-183e-4518-9ea5-04a8a913ab00}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/repeek/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "{41bb7295-c2bd-4e13-885f-dc67cb983c17}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/2black/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles = {
      personal = {
        id = 0;
        name = "personal";
        settings = baseSettings // {
          "browser.startup.page" = 3;
          "browser.startup.homepage" = "about:blank";
        };
        search = baseSearch;
      };

      work = {
        id = 1;
        name = "work";
        isDefault = false;
        settings = baseSettings;
        search = baseSearch;
      };
    };
  };
}
