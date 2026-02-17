{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) getExe;

  settings = {
    settingsVersion = 46;
    bar = {
      barType = "floating";
      position = "top";
      monitors = [ ];
      density = "comfortable";
      showOutline = false;
      showCapsule = false;
      capsuleOpacity = 1;
      backgroundOpacity = 0.93;
      useSeparateOpacity = false;
      floating = true;
      marginVertical = 9;
      marginHorizontal = 9;
      frameThickness = 8;
      frameRadius = 12;
      outerCorners = true;
      exclusive = true;
      hideOnOverview = false;
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
            labelMode = "none";
            occupiedColor = "secondary";
            reverseScroll = false;
            showApplications = false;
            showBadge = true;
            showLabelsOnlyWhenOccupied = true;
            unfocusedIconsOpacity = 1;
          }
        ];
        center = [
        ];
        right = [
          {
            blacklist = [
              "nm-applet"
              "bluetooth*"
            ];
            colorizeIcons = false;
            drawerEnabled = false;
            hidePassive = false;
            id = "Tray";
            pinned = [ ];
          }
          {
            compactMode = false;
            diskPath = "/";
            id = "SystemMonitor";
            showCpuTemp = true;
            showCpuUsage = true;
            showDiskUsage = false;
            showGpuTemp = true;
            showLoadAverage = false;
            showMemoryAsPercent = false;
            showMemoryUsage = true;
            showNetworkStats = false;
            showSwapUsage = false;
            useMonospaceFont = true;
            usePrimaryColor = false;
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
            id = "Network";
          }
          {
            displayMode = "onhover";
            id = "Bluetooth";
          }
          {
            displayMode = "alwaysHide";
            id = "Volume";
            middleClickCommand = "pwvucontrol || pavucontrol";
          }
          {
            displayMode = "alwaysHide";
            id = "Microphone";
            middleClickCommand = "pwvucontrol || pavucontrol";
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
            id = "KeyboardLayout";
            showIcon = true;
          }
          {
            customFont = "";
            formatHorizontal = "HH:mm ddd, MMM dd";
            formatVertical = "HH mm - dd MM";
            id = "Clock";
            tooltipFormat = "HH:mm ddd, MMM dd";
            useCustomFont = false;
            usePrimaryColor = true;
          }
          {
            hideWhenZero = false;
            hideWhenZeroUnread = false;
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
          id = "timer-card";
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
      transitionEdgeSmoothness = 0.05;
      panelPosition = "follow_bar";
      hideWallpaperFilenames = false;
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
    };
    appLauncher = {
      enableClipboardHistory = false;
      autoPasteClipboard = false;
      enableClipPreview = true;
      clipboardWrapText = true;
      clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
      clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
      position = "center";
      pinnedApps = [ ];
      useApp2Unit = false;
      sortByMostUsed = true;
      terminalCommand = "ghostty -e";
      customLaunchPrefixEnabled = false;
      customLaunchPrefix = "";
      viewMode = "list";
      showCategories = true;
      iconMode = "tabler";
      showIconBackground = false;
      enableSettingsSearch = true;
      ignoreMouseInput = false;
      screenshotAnnotationTool = "";
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
      cpuPollingInterval = 3000;
      tempPollingInterval = 3000;
      gpuPollingInterval = 3000;
      enableDgpuMonitoring = true;
      memPollingInterval = 3000;
      diskPollingInterval = 3000;
      networkPollingInterval = 3000;
      loadAvgPollingInterval = 3000;
      useCustomColors = false;
      warningColor = "";
      criticalColor = "";
      externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
    };
    dock = {
      enabled = false;
      position = "bottom";
      displayMode = "auto_hide";
      backgroundOpacity = 1;
      floatingRatio = 1;
      size = 1;
      onlySameOutput = true;
      monitors = [ ];
      pinnedApps = [ ];
      colorizeIcons = false;
      pinnedStatic = false;
      inactiveIndicators = false;
      deadOpacity = 0.6;
      animationSpeed = 2;
    };
    network = {
      wifiEnabled = true;
      bluetoothRssiPollingEnabled = false;
      bluetoothRssiPollIntervalMs = 10000;
      wifiDetailsViewMode = "grid";
      bluetoothDetailsViewMode = "grid";
      bluetoothHideUnnamedDevices = false;
    };
    sessionMenu = {
      enableCountdown = true;
      countdownDuration = 10000;
      position = "center";
      showHeader = true;
      largeButtonsStyle = false;
      largeButtonsLayout = "grid";
      showNumberLabels = true;
      powerOptions = [
        {
          action = "lock";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "suspend";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "hibernate";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "reboot";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "logout";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "shutdown";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
      ];
    };
    notifications = {
      enabled = true;
      monitors = [ ];
      location = "top_right";
      overlayLayer = true;
      backgroundOpacity = 1;
      respectExpireTimeout = false;
      lowUrgencyDuration = 8;
      normalUrgencyDuration = 8;
      criticalUrgencyDuration = 15;
      enableKeyboardLayoutToast = false;
      saveToHistory = {
        low = true;
        normal = true;
        critical = true;
      };
      sounds = {
        enabled = false;
        volume = 0.5;
        separateSounds = false;
        criticalSoundFile = "";
        normalSoundFile = "";
        lowSoundFile = "";
        excludedApps = "discord,firefox,chrome,chromium,edge";
      };
      enableMediaToast = false;
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
    desktopWidgets = {
      enabled = false;
      gridSnap = false;
      monitorWidgets = [ ];
    };
  };

  settingsFile = pkgs.writeText "noctalia-config.json" (builtins.toJSON settings);

  noctalia-shell = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
