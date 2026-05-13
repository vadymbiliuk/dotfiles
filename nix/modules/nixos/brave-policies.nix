{ pkgs, ... }:

{
  environment.etc."brave/policies/managed/brave-policies.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = false;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "DuckDuckGo";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
    ExtensionSettings = {
      "nngceckbapebfimnlniiiahkandclblb" = { toolbar_pin = "force_pinned"; incognito = true; };
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" = { toolbar_pin = "force_pinned"; incognito = true; };
      "fmkadmapgofadopljbjfkapdkoienihi" = { toolbar_pin = "force_pinned"; incognito = true; };
      "lmhkpmbekcpmknklioeibfkpmmfibljd" = { toolbar_pin = "force_pinned"; incognito = true; };
      "dbepggeogbaibhgnhhndojpepiihcmeb" = { toolbar_pin = "force_pinned"; incognito = true; };
      "mokknliiomknodkdmpcellamkopbdmao" = { toolbar_pin = "force_pinned"; incognito = true; };
    };
    ExtensionInstallForcelist = [
      "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx"
      "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx"
      "fmkadmapgofadopljbjfkapdkoienihi;https://clients2.google.com/service/update2/crx"
      "lmhkpmbekcpmknklioeibfkpmmfibljd;https://clients2.google.com/service/update2/crx"
      "dbepggeogbaibhgnhhndojpepiihcmeb;https://clients2.google.com/service/update2/crx"
      "mokknliiomknodkdmpcellamkopbdmao;https://clients2.google.com/service/update2/crx"
    ];
  };
}
