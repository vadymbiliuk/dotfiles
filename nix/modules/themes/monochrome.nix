{
  colors = {
    dark = {
      primary = "#aaaaaa";
      onPrimary = "#0a0a0a";
      secondary = "#888888";
      onSecondary = "#0a0a0a";
      tertiary = "#b0b0b0";
      onTertiary = "#0a0a0a";
      error = "#555555";
      onError = "#deeeed";
      surface = "#0a0a0a";
      onSurface = "#deeeed";
      surfaceVariant = "#191919";
      onSurfaceVariant = "#7a7a7a";
      outline = "#2a2a2a";
      shadow = "#000000";
      hover = "#aaaaaa";
      onHover = "#0a0a0a";

      terminal = {
        foreground = "#deeeed";
        background = "#0a0a0a";
        selectionFg = "#e0e0e0";
        selectionBg = "#3a3f4b";
        cursorText = "#0a0a0a";
        cursor = "#d6d6d6";
        normal = {
          black = "#1c1e23";
          red = "#555555";
          green = "#5e5e5e";
          yellow = "#666666";
          blue = "#6e6e6e";
          magenta = "#777777";
          cyan = "#7f7f7f";
          white = "#b0b0b0";
        };
        bright = {
          black = "#2b2e34";
          red = "#888888";
          green = "#8f8f8f";
          yellow = "#999999";
          blue = "#a2a2a2";
          magenta = "#ababab";
          cyan = "#b5b5b5";
          white = "#d6d6d6";
        };
      };
    };

    light = {
      primary = "#555555";
      onPrimary = "#f0f0f0";
      secondary = "#777777";
      onSecondary = "#f0f0f0";
      tertiary = "#444444";
      onTertiary = "#f0f0f0";
      error = "#999999";
      onError = "#f0f0f0";
      surface = "#dddddd";
      onSurface = "#191919";
      surfaceVariant = "#e8e8e8";
      onSurfaceVariant = "#555555";
      outline = "#cccccc";
      shadow = "#fafafa";
      hover = "#555555";
      onHover = "#f0f0f0";

      terminal = {
        foreground = "#191919";
        background = "#dddddd";
        selectionFg = "#e0e0e0";
        selectionBg = "#555555";
        cursorText = "#dddddd";
        cursor = "#555555";
        normal = {
          black = "#e8e8e8";
          red = "#999999";
          green = "#8f8f8f";
          yellow = "#888888";
          blue = "#777777";
          magenta = "#666666";
          cyan = "#555555";
          white = "#191919";
        };
        bright = {
          black = "#cccccc";
          red = "#aaaaaa";
          green = "#a2a2a2";
          yellow = "#999999";
          blue = "#888888";
          magenta = "#777777";
          cyan = "#666666";
          white = "#000000";
        };
      };
    };

    editor = {
      foreground = "#DEEEED";
      background = "#0A0A0A";
      cursor = "#DEEEED";
      cursorText = "#080808";
      selectionBg = "#7A7A7A";
      urlColor = "#D7007D";

      black = "#080808";
      brightBlack = "#444444";
      red = "#D70000";
      green = "#789978";
      yellow = "#ffAA88";
      blue = "#7788AA";
      magenta = "#D7007D";
      cyan = "#708090";
      white = "#DEEEED";

      winSeparator = "#3c4048";
      diffAdd = "#2a3a2a";
      diffChange = "#2a2a3a";
      diffDelete = "#3a2a2a";
      diffText = "#3a3a5a";
    };

    lockscreen = {
      ring = "808080cc";
      keyHighlight = "aaaaaaff";
      line = "00000000";
      inside = "40404080";
      separator = "00000000";
      text = "c8c8c8ff";
    };

    browser = {
      toolbarBg = "rgba(10, 10, 10, 0.6)";
      iconFill = "#deeeed";
      tabSelectedBg = "rgba(60, 60, 60, 0.4)";
      urlbarBg = "rgba(30, 30, 30, 0.5)";
    };

    greeter = {
      border = "#3a3a3a";
      text = "#deeeed";
      prompt = "#888888";
      time = "#555555";
      action = "#888888";
      button = "#deeeed";
      container = "#0a0a0a";
      input = "#deeeed";
    };

    wallpaper = {
      fill = "#000000";
      solid = "#1a1a2e";
    };

    newTab = "#000000";
  };

  layout = {
    gaps = 8;
    cornerRadius = 10;
    focusRingWidth = 3;
    focusRingAlphaActive = "a6";
    focusRingAlphaInactive = "73";

    bar = {
      marginVertical = 9;
      marginHorizontal = 9;
      frameThickness = 8;
      frameRadius = 12;
      backgroundOpacity = 0.93;
    };

    terminal = {
      paddingWidth = 14;
      marginWidth = "2 0 0 2";
      backgroundOpacity = "0.8";
      backgroundBlur = 64;
    };

    greeter = {
      width = 60;
      windowPadding = 2;
      containerPadding = 2;
      promptPadding = 1;
    };

    lockscreen = {
      indicatorRadius = 100;
      indicatorThickness = 7;
      effectBlur = "8x3";
      effectVignette = "0.5:0.5";
      fadeIn = 0.2;
    };

    blur = {
      noise = 0.05;
      saturation = 1.5;
    };

    noctalia = {
      radiusRatio = 0.5;
      iRadiusRatio = 0.5;
      boxRadiusRatio = 1;
      screenRadiusRatio = 1;
      dimmerOpacity = 0.15;
      animationSpeed = 1;
    };
  };
}
