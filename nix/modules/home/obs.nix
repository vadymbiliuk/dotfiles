{
  config,
  pkgs,
  lib,
  ...
}:

let
  obs-cmd = lib.getExe pkgs.obs-cmd;

  replayDir = "${config.home.homeDirectory}/Videos/Replays";
  recordingDir = "${config.home.homeDirectory}/Videos/Recordings";

  replaySaveScript = pkgs.writeShellScript "obs-replay-save" ''
    ${obs-cmd} replay save && ${lib.getExe pkgs.libnotify} -t 3000 "OBS" "Replay saved" || true
  '';

  profileIni = ''
    [General]
    Name=Recording

    [Output]
    Mode=Advanced
    FilenameFormatting=%CCYY-%MM-%DD %hh-%mm-%ss

    [AdvOut]
    RecType=Standard
    RecFilePath=${recordingDir}
    RecFormat2=mkv
    RecEncoder=jim_nvenc
    RecTracks=3
    RecRB=true
    RecRBTime=30
    RecRBSize=512
    RecRBPrefix=Replay
    Track1Bitrate=192
    Track2Bitrate=192
    Track3Bitrate=192

    [Video]
    BaseCX=2560
    BaseCY=1440
    OutputCX=2560
    OutputCY=1440
    FPSType=0
    FPSCommon=60
    FPSInt=60
    FPSNum=60
    FPSDen=1
    ScaleType=bicubic
    ColorFormat=NV12
    ColorSpace=709
    ColorRange=Partial

    [Audio]
    SampleRate=48000
    ChannelSetup=Stereo
  '';

  encoderJson = builtins.toJSON {
    id = "jim_nvenc";
    name = "Recording";
    settings = {
      rate_control = "CQP";
      cqp = 20;
      preset2 = "p5";
      profile = "high";
      lookahead = true;
      bf = 2;
      keyint_sec = 2;
    };
  };
in
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-pipewire-audio-capture
      obs-websocket
      obs-gstreamer
      obs-replay-source
    ];
  };

  home.packages = [
    pkgs.obs-cmd
  ];

  home.activation.obsSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${replayDir}" "${recordingDir}"

    profile_dir="${config.home.homeDirectory}/.config/obs-studio/basic/profiles/Recording"
    if [ ! -f "$profile_dir/basic.ini" ]; then
      run mkdir -p "$profile_dir"
      cat > "$profile_dir/basic.ini" << 'PROFILE'
${profileIni}
PROFILE
    fi

    encoder_dir="$profile_dir/recordEncoder.json"
    if [ ! -f "$encoder_dir" ]; then
      cat > "$encoder_dir" << 'ENCODER'
${encoderJson}
ENCODER
    fi
  '';
}
