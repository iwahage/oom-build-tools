# oom-build-tools

OpenOrienteering Mapper (OOM) Android 版を、**Windows + WSL2 Ubuntu + self-hosted GitHub Actions runner** で再現性高くビルドするための補助スクリプト集です。

このリポジトリでは、以下を目的にしています。

- OOM Android APK を安定してビルドする
- ビルド手順をスクリプト化して再利用しやすくする
- GitHub Actions から手動実行できるようにする
- ビルド済み APK を artifact として取得できるようにする

---

## 構成概要

ビルドは以下の構成で動作します。

- **Windows**
  - GitHub Actions self-hosted runner を実行
  - Android SDK / Build Tools / apksigner / debug.keystore を保持
- **WSL2 Ubuntu**
  - OpenOrienteering superbuild を実行
  - 実際の Android ビルドを担当
- **GitHub Actions**
  - Windows 上の self-hosted runner にジョブを流す
  - WSL 内で `oom-run.sh` を実行
  - 生成された APK と build log を artifact 化する

---

## 前提環境

以下を前提としています。

- Windows 10 / 11
- WSL2 Ubuntu
- Android Studio
- Android SDK Build Tools
- GitHub self-hosted runner
- OOM superbuild を WSL 上に構築済み
- OOM Android APK のビルドに一度成功していること

---

## ディレクトリ前提

この README は以下の配置を前提にしています。

```text
~/src/oom-build-tools
~/src/superbuild
