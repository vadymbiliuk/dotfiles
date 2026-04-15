{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) getExe;

  settings = {
    settingsVersion = 53;
    bar = {
      barType = "floating";
      position = "top";
      monitors = [ ];
      density = "comfortable";
      showOutline = false;
      showCapsule = false;
      capsuleOpacity = 1;
      capsuleColorKey = "none";
      backgroundOpacity = 0.93;
      useSeparateOpacity = false;
      floating = true;
      marginVertical = 9;
      marginHorizontal = 9;
      frameThickness = 8;
      frameRadius = 12;
      outerCorners = true;
      hideOnOverview = false;
      displayMode = "always_visible";
      autoHideDelay = 500;
      autoShowDelay = 150;
      widgets = {
        left = [
          {
            colorizeDistroLogo = false;
            colorizeSystemIcon = "primary";
            customIconPath = "";
            enableColorization = true;
            icon = "noctalia";
            id = "ControlCenter";
            useDistroLogo = true;
          }
          {
            characterCount = 2;
            colorizeIcons = false;
            emptyColor = "secondary";
            enableScrollWheel = true;
            focusedColor = "primary";
            followFocusedScreen = false;
            groupedBorderOpacity = 1;
            hideUnoccupied = false;
            iconScale = 0.8;
            id = "Workspace";
            labelMode = "index";
            occupiedColor = "secondary";
            pillSize = 0.5700000000000001;
            showApplications = false;
            showBadge = true;
            showLabelsOnlyWhenOccupied = true;
            unfocusedIconsOpacity = 1;
          }
        ];
        center = [ ];
        right = [
          {
            defaultSettings = {
              hideInactive = true;
              removeMargins = false;
            };
            id = "plugin:privacy-indicator";
          }
          {
            blacklist = [
              "nm-applet"
              "bluetooth*"
            ];
            chevronColor = "none";
            colorizeIcons = false;
            drawerEnabled = false;
            hidePassive = false;
            id = "Tray";
            pinned = [ ];
          }
          {
            compactMode = false;
            diskPath = "/";
            iconColor = "none";
            id = "SystemMonitor";
            showCpuFreq = false;
            showCpuTemp = true;
            showCpuUsage = true;
            showDiskAvailable = false;
            showDiskUsage = false;
            showDiskUsageAsPercent = false;
            showGpuTemp = true;
            showLoadAverage = false;
            showMemoryAsPercent = false;
            showMemoryUsage = true;
            showNetworkStats = false;
            showSwapUsage = false;
            textColor = "none";
            useMonospaceFont = true;
            usePadding = false;
          }
          {
            defaultSettings = {
              compactMode = false;
              defaultPeerAction = "copy-ip";
              hideDisconnected = false;
              pingCount = 5;
              refreshInterval = 5000;
              showIpAddress = true;
              showPeerCount = true;
              terminalCommand = "";
            };
            id = "plugin:tailscale";
          }
          {
            displayMode = "onhover";
            iconColor = "none";
            id = "Network";
            textColor = "none";
          }
          {
            displayMode = "onhover";
            iconColor = "none";
            id = "Bluetooth";
            textColor = "none";
          }
          {
            displayMode = "alwaysHide";
            iconColor = "none";
            id = "Volume";
            middleClickCommand = "pwvucontrol || pavucontrol";
            textColor = "none";
          }
          {
            displayMode = "alwaysHide";
            iconColor = "none";
            id = "Microphone";
            middleClickCommand = "pwvucontrol || pavucontrol";
            textColor = "none";
          }
          {
            defaultSettings = {
              showConditionIcon = true;
              showTempUnit = true;
              showTempValue = true;
            };
            id = "plugin:weather-indicator";
          }
          {
            displayMode = "forceOpen";
            iconColor = "none";
            id = "KeyboardLayout";
            showIcon = true;
            textColor = "none";
          }
          {
            clockColor = "none";
            customFont = "";
            formatHorizontal = "HH:mm ddd, MMM dd";
            formatVertical = "HH mm - dd MM";
            id = "Clock";
            tooltipFormat = "HH:mm ddd, MMM dd";
            useCustomFont = false;
          }
          {
            hideWhenZero = false;
            hideWhenZeroUnread = false;
            iconColor = "none";
            id = "NotificationHistory";
            showUnreadBadge = true;
            unreadBadgeColor = "primary";
          }
        ];
      };
      screenOverrides = [ ];
    };
    general = {
      avatarImage = "/home/zooki/.face";
      dimmerOpacity = 0.15;
      showScreenCorners = false;
      forceBlackScreenCorners = false;
      scaleRatio = 1;
      radiusRatio = 0.5;
      iRadiusRatio = 0.5;
      boxRadiusRatio = 1;
      screenRadiusRatio = 1;
      animationSpeed = 1;
      animationDisabled = false;
      compactLockScreen = false;
      lockScreenAnimations = false;
      lockOnSuspend = true;
      showSessionButtonsOnLockScreen = true;
      showHibernateOnLockScreen = false;
      enableShadows = true;
      shadowDirection = "bottom_right";
      shadowOffsetX = 2;
      shadowOffsetY = 3;
      language = "";
      allowPanelsOnScreenWithoutBar = true;
      showChangelogOnStartup = true;
      telemetryEnabled = false;
      enableLockScreenCountdown = true;
      lockScreenCountdownDuration = 10000;
      autoStartAuth = false;
      allowPasswordWithFprintd = false;
      clockStyle = "custom";
      clockFormat = "hh\\nmm";
      passwordChars = false;
      lockScreenMonitors = [ ];
      lockScreenBlur = 0;
      lockScreenTint = 0;
      keybinds = {
        keyUp = [ "Up" ];
        keyDown = [ "Down" ];
        keyLeft = [ "Left" ];
        keyRight = [ "Right" ];
        keyEnter = [ "Return" ];
        keyEscape = [ "Esc" ];
        keyRemove = [ "Del" ];
      };
      reverseScroll = false;
    };
    ui = {
      fontDefault = "BerkeleyMonoMinazuki Nerd Font Mono";
      fontFixed = "BerkeleyMonoMinazuki Nerd Font Mono";
      fontDefaultScale = 1;
      fontFixedScale = 1;
      tooltipsEnabled = true;
      panelBackgroundOpacity = 1;
      panelsAttachedToBar = true;
      settingsPanelMode = "centered";
      wifiDetailsViewMode = "grid";
      bluetoothDetailsViewMode = "grid";
      networkPanelView = "wifi";
      bluetoothHideUnnamedDevices = false;
      boxBorderEnabled = true;
    };
    location = {
      name = "Kyiv";
      weatherEnabled = true;
      weatherShowEffects = true;
      useFahrenheit = false;
      use12hourFormat = false;
      showWeekNumberInCalendar = false;
      showCalendarEvents = true;
      showCalendarWeather = true;
      analogClockInCalendar = false;
      firstDayOfWeek = -1;
      hideWeatherTimezone = false;
      hideWeatherCityName = false;
    };
    calendar = {
      cards = [
        {
          enabled = true;
          id = "calendar-header-card";
        }
        {
          enabled = true;
          id = "calendar-month-card";
        }
        {
          enabled = true;
          id = "weather-card";
        }
      ];
    };
    wallpaper = {
      enabled = false;
      overviewEnabled = false;
      directory = "/home/zooki/Pictures/Wallpapers";
      monitorDirectories = [ ];
      enableMultiMonitorDirectories = false;
      showHiddenFiles = false;
      viewMode = "single";
      setWallpaperOnAllMonitors = true;
      fillMode = "crop";
      fillColor = "#000000";
      useSolidColor = false;
      solidColor = "#1a1a2e";
      automationEnabled = false;
      wallpaperChangeMode = "random";
      randomIntervalSec = 300;
      transitionDuration = 1500;
      transitionType = "random";
      skipStartupTransition = false;
      transitionEdgeSmoothness = 0.05;
      panelPosition = "follow_bar";
      hideWallpaperFilenames = false;
      overviewBlur = 0.4;
      overviewTint = 0.6;
      useWallhaven = false;
      wallhavenQuery = "";
      wallhavenSorting = "relevance";
      wallhavenOrder = "desc";
      wallhavenCategories = "111";
      wallhavenPurity = "100";
      wallhavenRatios = "";
      wallhavenApiKey = "";
      wallhavenResolutionMode = "atleast";
      wallhavenResolutionWidth = "";
      wallhavenResolutionHeight = "";
      sortOrder = "name";
      favorites = [ ];
    };
    appLauncher = {
      enableClipboardHistory = true;
      autoPasteClipboard = false;
      enableClipPreview = true;
      clipboardWrapText = true;
      clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
      clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
      position = "center";
      pinnedApps = [ ];
      useApp2Unit = false;
      sortByMostUsed = true;
      terminalCommand = "kitty -e";
      customLaunchPrefixEnabled = false;
      customLaunchPrefix = "";
      viewMode = "list";
      showCategories = true;
      iconMode = "tabler";
      showIconBackground = true;
      enableSettingsSearch = true;
      enableWindowsSearch = true;
      enableSessionSearch = true;
      ignoreMouseInput = false;
      screenshotAnnotationTool = "";
      overviewLayer = true;
      density = "compact";
    };
    controlCenter = {
      position = "close_to_bar_button";
      diskPath = "/";
      shortcuts = {
        left = [
          { id = "Network"; }
          { id = "Bluetooth"; }
        ];
        right = [
          { id = "Notifications"; }
          { id = "PowerProfile"; }
        ];
      };
      cards = [
        {
          enabled = true;
          id = "profile-card";
        }
        {
          enabled = true;
          id = "shortcuts-card";
        }
        {
          enabled = true;
          id = "audio-card";
        }
        {
          enabled = false;
          id = "brightness-card";
        }
        {
          enabled = true;
          id = "weather-card";
        }
        {
          enabled = true;
          id = "media-sysmon-card";
        }
      ];
    };
    systemMonitor = {
      cpuWarningThreshold = 80;
      cpuCriticalThreshold = 90;
      tempWarningThreshold = 80;
      tempCriticalThreshold = 90;
      gpuWarningThreshold = 80;
      gpuCriticalThreshold = 90;
      memWarningThreshold = 80;
      memCriticalThreshold = 90;
      swapWarningThreshold = 80;
      swapCriticalThreshold = 90;
      diskWarningThreshold = 80;
      diskCriticalThreshold = 90;
      diskAvailWarningThreshold = 20;
      diskAvailCriticalThreshold = 10;
      batteryWarningThreshold = 20;
      batteryCriticalThreshold = 5;
      enableDgpuMonitoring = true;
      useCustomColors = false;
      warningColor = "";
      criticalColor = "";
      externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
    };
    dock = {
      enabled = false;
      position = "bottom";
      displayMode = "auto_hide";
      dockType = "floating";
      backgroundOpacity = 1;
      floatingRatio = 1;
      size = 1;
      onlySameOutput = true;
      monitors = [ ];
      pinnedApps = [ ];
      colorizeIcons = false;
      showLauncherIcon = false;
      launcherPosition = "end";
      launcherIconColor = "none";
      pinnedStatic = false;
      inactiveIndicators = false;
      groupApps = false;
      groupContextMenuMode = "extended";
      groupClickAction = "cycle";
      groupIndicatorStyle = "dots";
      deadOpacity = 0.6;
      animationSpeed = 2;
      sitOnFrame = false;
      showFrameIndicator = true;
    };
    network = {
      wifiEnabled = true;
      airplaneModeEnabled = false;
      bluetoothRssiPollingEnabled = false;
      bluetoothRssiPollIntervalMs = 10000;
      wifiDetailsViewMode = "grid";
      bluetoothDetailsViewMode = "grid";
      bluetoothHideUnnamedDevices = false;
      disableDiscoverability = false;
    };
    sessionMenu = {
      enableCountdown = false;
      countdownDuration = 10000;
      position = "center";
      showHeader = true;
      showKeybinds = true;
      largeButtonsStyle = false;
      largeButtonsLayout = "grid";
      powerOptions = [
        {
          action = "lock";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "1";
        }
        {
          action = "suspend";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "2";
        }
        {
          action = "hibernate";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "3";
        }
        {
          action = "reboot";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "4";
        }
        {
          action = "logout";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "5";
        }
        {
          action = "shutdown";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "6";
        }
        {
          action = "rebootToUefi";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "";
        }
      ];
    };
    notifications = {
      enabled = true;
      enableMarkdown = false;
      density = "compact";
      monitors = [ ];
      location = "top_right";
      overlayLayer = true;
      backgroundOpacity = 1;
      respectExpireTimeout = false;
      lowUrgencyDuration = 3;
      normalUrgencyDuration = 6;
      criticalUrgencyDuration = 9;
      clearDismissed = true;
      saveToHistory = {
        low = true;
        normal = true;
        critical = true;
      };
      sounds = {
        enabled = true;
        volume = 0.5;
        separateSounds = false;
        criticalSoundFile = "";
        normalSoundFile = "";
        lowSoundFile = "";
        excludedApps = "discord,firefox,chrome,chromium,edge";
      };
      enableMediaToast = false;
      enableKeyboardLayoutToast = false;
      enableBatteryToast = true;
    };
    osd = {
      enabled = true;
      location = "bottom";
      autoHideMs = 3000;
      overlayLayer = true;
      backgroundOpacity = 1;
      enabledTypes = [
        0
        1
        2
        4
        3
      ];
      monitors = [ ];
    };
    audio = {
      volumeStep = 5;
      volumeOverdrive = false;
      cavaFrameRate = 30;
      visualizerType = "linear";
      mprisBlacklist = [ ];
      preferredPlayer = "";
      volumeFeedback = false;
    };
    brightness = {
      brightnessStep = 5;
      enforceMinimum = true;
      enableDdcSupport = false;
    };
    colorSchemes = {
      useWallpaperColors = false;
      predefinedScheme = "ZookiMono";
      darkMode = true;
      schedulingMode = "off";
      manualSunrise = "06:30";
      manualSunset = "18:30";
      generationMethod = "tonal-spot";
      monitorForColors = "";
    };
    templates = {
      activeTemplates = [
        {
          enabled = true;
          id = "btop";
        }
        {
          enabled = true;
          id = "discord";
        }
        {
          enabled = true;
          id = "gtk";
        }
        {
          enabled = true;
          id = "telegram";
        }
      ];
      enableUserTheming = false;
    };
    nightLight = {
      enabled = false;
      forced = false;
      autoSchedule = true;
      nightTemp = "4000";
      dayTemp = "6500";
      manualSunrise = "06:30";
      manualSunset = "18:30";
    };
    hooks = {
      enabled = false;
      wallpaperChange = "";
      darkModeChange = "";
      screenLock = "";
      screenUnlock = "";
      performanceModeEnabled = "";
      performanceModeDisabled = "";
      startup = "";
      session = "";
    };
    plugins = {
      autoUpdate = false;
    };
    desktopWidgets = {
      enabled = false;
      gridSnap = false;
      monitorWidgets = [ ];
    };
  };

  settingsFile = pkgs.writeText "noctalia-config.json" (builtins.toJSON settings);

  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    withPolkit = true;
  };

  pkgsWithQuickshell = pkgs.extend (
    final: prev: {
      inherit quickshell;
    }
  );

  noctalia-shell = pkgsWithQuickshell.callPackage "${inputs.noctalia}/nix/package.nix" {
    version = inputs.noctalia.shortRev or "dev";
  };

  noctalia-wrapped = pkgs.symlinkJoin {
    name = "noctalia-shell-wrapped";
    paths = [ noctalia-shell ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/noctalia-shell \
        --set NOCTALIA_SETTINGS_FILE ${settingsFile}
    '';
  };
in
{
  environment.systemPackages = [ noctalia-wrapped ];
}
