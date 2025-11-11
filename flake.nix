{
  description = "Flake utils demo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    xbwwj = {
      url = "github:xbwwj/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    skland-daily-attendance = {
      url = "github:enpitsuLin/skland-daily-attendance";
      flake = false;
    };

    mihoyo-bbs-tools = {
      url = "github:Womsxd/MihoyoBBSTools";
      flake = false;
    };

    kuro-login = {
      url = "github:mxyooR/Kuro_login";
      flake = false;
    };
    kuro-autosignin = {
      url = "github:mxyooR/Kuro-autosignin";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = rec {
          # node_modules 太大，故打包
          skland-daily-attendance-bundled = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
            pname = "skland-daily-attendance";
            version = "0.1.0";
            src = inputs.skland-daily-attendance;

            nativeBuildInputs = with pkgs; [
              nodejs
              pnpm.configHook
              esbuild
            ];

            pnpmDeps = pkgs.pnpm.fetchDeps {
              inherit (finalAttrs) pname version;
              fetcherVersion = 2;
              hash = "sha256-nnSH7VwdLTYH/1hNJT7Vs7Y2mdtf6Vqzq+vyj+yD1do=";
            };

            buildPhase = ''
              pnpm build
              esbuild apps/node/src/index.ts --bundle --platform=node --format=esm --outfile=skland-daily-attendance.mjs
            '';

            installPhase = ''
              mkdir $out
              cp skland-daily-attendance.mjs $out
            '';
          });

          # 森空岛
          gacha-sign-hypergryph = pkgs.writeShellApplication {
            name = "gacha-sign-hypergryph";
            runtimeInputs = [
              pkgs.nodejs
              skland-daily-attendance-bundled
            ];
            text = ''
              cd "$HOME/.config/gacha-sign/hypergryph"
              node ${skland-daily-attendance-bundled}/skland-daily-attendance.mjs
            '';
          };

          # 米游社
          gacha-sign-mihoyo = pkgs.writeShellApplication {
            name = "gacha-sign-mihoyo";
            runtimeInputs = [
              (pkgs.python3.withPackages (
                pp: with pp; [
                  httpx
                  crontab
                  pyyaml
                  pytz
                ]
              ))
              inputs.mihoyo-bbs-tools
            ];
            text = ''
              export AutoMihoyoBBS_config_path="$HOME/.config/gacha-sign/mihoyo"
              python ${inputs.mihoyo-bbs-tools}/main.py
            '';
          };

          # 库街区
          gacha-sign-kuro = pkgs.writeShellApplication {
            name = "gacha-sign-kuro";
            runtimeInputs = [
              (pkgs.python3.withPackages (
                pp: with pp; [
                  requests
                  httpx
                  crontab
                  loguru
                  pytz
                  pyyaml
                ]
              ))
              inputs.kuro-autosignin
            ];
            text = ''
              export KuroBBS_config_path="$HOME/.config/gacha-sign/kuro"
              python ${inputs.kuro-autosignin}/main.py
            '';
          };

          # 库街区登录
          gacha-sign-kuro-login = pkgs.writeShellApplication {
            name = "gacha-sign-kuro-login";
            runtimeInputs = [
              (pkgs.python3.withPackages (
                pp: with pp; [
                  requests
                  loguru
                  pycryptodome
                  opencv-python
                  pillow
                  inputs.xbwwj.packages.${pkgs.system}.python3Packages.ddddocr
                  torch
                  torchvision
                  open-clip-torch
                  sentence-transformers
                  numpy
                  pydash
                  urllib3
                ]
              ))
              inputs.kuro-login
            ];
            text = ''
              python ${inputs.kuro-login}/sms_send.py
            '';
          };

        };
      }
    );
}
