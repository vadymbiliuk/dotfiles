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
    
    "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button"],"dirtyAreaCache":["nav-bar","toolbar-menubar","TabsToolbar","PersonalToolbar"],"currentVersion":20,"newElementCount":0}'';
    "browser.tabs.inTitlebar" = 1;

    "browser.urlbar.suggest.searches" = true;
    "browser.search.suggest.enabled" = true;
    
    "ui.key.menuAccessKeyFocuses" = false;
  };

  baseSearch = {
    force = true;
    default = "DuckDuckGo";
    engines = {
      "DuckDuckGo" = {
        urls = [{
          template = "https://duckduckgo.com/";
          params = [{
            name = "q";
            value = "{searchTerms}";
          }];
        }];
        iconUpdateURL = "https://duckduckgo.com/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = [ "@ddg" ];
      };

      "Google".metaData.hidden = true;
      "Amazon.com".metaData.hidden = true;
      "Bing".metaData.hidden = true;
      "eBay".metaData.hidden = true;
      "Wikipedia (en)".metaData.alias = "@wiki";
    };
  };
in {
  programs.firefox = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.firefox else null;

    policies = {
      ExtensionSettings = {
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
          pinned = true;
        };
        "addon@darkreader.org" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          pinned = true;
        };
        "@react-devtools" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/react-devtools/latest.xpi";
          installation_mode = "force_installed";
          pinned = true;
        };
        "extension@redux.devtools" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/reduxdevtools/latest.xpi";
          installation_mode = "force_installed";
          pinned = true;
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
