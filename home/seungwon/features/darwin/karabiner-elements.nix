{pkgs, ...}: let
  swapIfNotTerminal = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers = {
        optional = ["any"];
      };
    };
    to = [{key_code = to;}];
    conditions = [
      {
        type = "frontmost_application_unless";
        bundle_identifiers = [
          "^com\\.apple\\.Terminal$"
          "^com\\.utmapp\\.utm$"
          "^org\\.alacritty$"
          "^com\\.mitchellh\\.ghostty$"
        ];
        file_paths = ["/etc/profiles/per-user/felix/bin/alacritty"];
      }
    ];
  };
  swapIfInternal = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers = {
        optional = ["any"];
      };
    };
    to = [{key_code = to;}];
    conditions = [
      {
        type = "device_if";
        identifiers = [{is_built_in_keyboard = true;}];
      }
    ];
  };
  swap = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers = {
        optional = ["any"];
      };
    };
    to = [{key_code = to;}];
    conditions = [];
  };

  # 한/영 전환 토글 함수 정의
  toggleKoreanEnglish = key_code: [
    # 한글 → 영어 전환
    {
      type = "basic";
      from = {
        key_code = key_code;
        modifiers = {
          optional = ["any"];
        };
      };
      to = [
        {
          "select_input_source" = {
            "language" = "^en$";
          };
        }
      ];
      conditions = [
        {
          "type" = "input_source_if";
          "input_sources" = [
            {
              "language" = "^ko$";
            }
          ];
        }
      ];
    }
    # 영어 → 한글 전환
    {
      type = "basic";
      from = {
        key_code = key_code;
        modifiers = {
          optional = ["any"];
        };
      };
      to = [
        {
          "select_input_source" = {
            "input_source_id" = "^com\\.apple\\.inputmethod\\.Korean\\.2SetKorean$";
            "language" = "^ko$";
          };
        }
      ];
      conditions = [
        {
          "type" = "input_source_unless";
          "input_sources" = [
            {
              "language" = "^ko$";
            }
          ];
        }
      ];
    }
  ];
in {
  home.file.karabiner = {
    target = ".config/karabiner/assets/complex_modifications/nix.json";
    text = builtins.toJSON {
      title = "Nix Managed";
      rules = [
        {
          description = "한/영 전환 토글 (lang1 키 사용)";
          manipulators = toggleKoreanEnglish "f13";
        }
      ];
    };
  };
  launchd.agents.karabiner = {
    enable = true;
    config = {
      Label = "org.nixos.karabiner-elements";
      ProgramArguments = [
        "${pkgs.karabiner-elements}/Applications/Karabiner-Elements.app/Contents/MacOS/Karabiner-Elements"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
