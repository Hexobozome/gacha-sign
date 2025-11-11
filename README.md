# gacha-sign

本项目选取整合了部分抽卡游戏自动签到程序，统一其调用格式和配置目录。

仅支持 Nix 包管理器（Linux, macOS 和 Android Termux）。

- 森空岛 [enpitsuLin/skland-daily-attendance](https://github.com/enpitsuLin/skland-daily-attendance)
- 米游社 [Womsxd/MihoyoBBSTools](https://github.com/Womsxd/MihoyoBBSTools)
- 库街区 [mxyooR/Kuro-autosignin](https://github.com/mxyooR/Kuro-autosignin)

## 整合格式

原项目使用 Python, TypeScript 等不同语言，且缺少项目文件[^1]，需要进入特定环境才能运行。
现统一为直接可用之 bash 命令 `gacha-sign-*`, 如 `gacha-sign-skland`.

[^1]: `pyproject.toml`, `package.json#entry` 等，缺少这些很难打包

原项目中配置文件散佚各处，如项目中 `config/` 或者环境变量, 现统一为 `~/.config/gacha-sign/**/`.

## 各

### 森空岛

- 程序：`gacha-sign-hypergryph`
- 配置文件：`~/.config/gacha-sign/hypergryph/.env`

### 米游社

- 程序：`gacha-sign-mihoyo`
- 配置文件：`~/.config/gacha-sign/mihoyo/config.yaml`

### 库街区

- 程序：`gacha-sign-kuro`
- 配置文件：`~/.config/gacha-sign/kuro/<name>.yaml`

额外程序: `gacha-sign-kuro-login` 用于获取登录信息。
