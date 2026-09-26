{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.headful;
in
{
  options.profiles.headful = {
    enable = lib.mkEnableOption "headful";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.profiles.server.enable;
        message = "The headful profile is not compatible with the server profile.";
      }
    ];

    environment = {
      systemPackages = [
        pkgs.wl-clipboard
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SDL_VIDEODRIVER = "wayland,x11";
      };
    };

    fonts = {
      enableDefaultPackages = true;
      packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-cjk-serif
        pkgs.noto-fonts-monochrome-emoji
        pkgs.noto-fonts-color-emoji

        pkgs.inter
        pkgs.ibm-plex
        pkgs.libertinus

        pkgs.nerd-fonts.iosevka
        pkgs.nerd-fonts.inconsolata
        pkgs.nerd-fonts.fira-code
      ];

      fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [
            "Noto Sans Mono"
          ];
          sansSerif = [
            "Noto Sans"
          ];
          serif = [
            "Noto Serif"
          ];
          emoji = [
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
      };
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    networking = {
      stevenblack.enable = true;
      hosts = {
        "0.0.0.0" = [
          "chatgpt.com"
          "chat.openai.com"
          "openai.com"
          "ai.com"
          "oaiusercontent.com"
          "oaistatic.com"
          "claude.ai"
          "claude.com"
          "clau.de"
          "anthropic.com"
          "claudeusercontent.com"
          "gemini.google.com"
          "aistudio.google.com"
          "ai.google.dev"
          "generativelanguage.googleapis.com"
          "duck.ai"
          "grok.com"
          "x.ai"
          "g.ai"
          "deepseek.com"
          "perplexity.ai"
          "copilot.microsoft.com"
          "copilot.com"
          "githubcopilot.com"
          "meta.ai"
          "mistral.ai"
          "mistralcdn.net"
          "cohere.com"
          "cohere.ai"
          "groq.com"
          "openrouter.ai"
          "together.ai"
          "together.xyz"
          "replicate.com"
          "fireworks.ai"
          "poe.com"
          "character.ai"
          "you.com"
          "pi.ai"
          "inflection.ai"
          "qwen.ai"
          "z.ai"
          "chatglm.cn"
          "bigmodel.cn"
          "ai21.com"
          "stability.ai"
          "midjourney.com"
          "leonardo.ai"
          "ideogram.ai"
          "blackbox.ai"
          "runwayml.com"
          "lumalabs.ai"
          "pika.art"
          "krea.ai"
          "gamma.app"
          "udio.com"
          "suno.com"
          "elevenlabs.io"
          "deepai.org"
          "phind.com"
          "cursor.com"
          "windsurf.com"
          "codeium.com"
          "tabnine.com"
          "sourcegraph.com"
          "firefly.adobe.com"
          "canva.com"
          "perplexity.ai"
          "venice.ai"
          "jan.ai"
          "photoroom.com"
          "clipdrop.co"
          "jasper.ai"
          "writesonic.com"
          "copy.ai"
          "otter.ai"
          "descript.com"
          "synthesia.io"
          "heygen.com"
          "hf.space"
          "modal.com"
          "runpod.io"
          "anyscale.com"
          "lambdal.com"
          "vast.ai"
        ];
      };
    };
  };
}
