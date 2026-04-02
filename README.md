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

---

## Mapper ソースについて重要な注意

通常の開発用 clone は以下です。

```text
~/src/mapper

しかし、Android APK のビルドで実際に参照される Mapper ソースは、superbuild 内の以下です。
~/src/superbuild/build-android/source/openorienteering-mapper-git-master
そのため、~/src/mapper 側で branch を切り替えたりコードを変更しても、そのままでは APK に反映されません。

APK に反映させるには、ビルド前に ~/src/mapper の内容を superbuild 内ソースへ同期する必要があります。
そのため、~/src/mapper 側で branch を切り替えたりコードを変更しても、そのままでは APK に反映されません。
そのため、~/src/mapper 側で branch を切り替えたりコードを変更しても、そのままでは APK に反映されません。
例：
rsync -a --delete --exclude '.git' \
  ~/src/mapper/ \
  ~/src/superbuild/build-android/source/openorienteering-mapper-git-master/
このリポジトリの oom-build-android.sh では、ビルド前にこの同期を行う前提です。
branch を切り替えてビルドする場合
1. ~/src/mapper で対象 branch を checkout
2. superbuild 内ソースへ同期
3. oom-run.sh を実行
4. 必要なら GitHub Actions で APK を artifact 化

例:
git -C ~/src/mapper checkout custom-toolbar

rsync -a --delete --exclude '.git' \
  ~/src/mapper/ \
  ~/src/superbuild/build-android/source/openorienteering-mapper-git-master/

bash -lc '~/src/oom-build-tools/oom-run.sh'

よくあるハマりどころ
~/src/mapper に実装があるのに APK に反映されない
GitHub 上の branch には変更があるのに APK が古い
Codex が別 clone を編集していて、実際のビルド元とずれている

このような場合は、まず superbuild 内ソースに変更が入っているか確認してください。
git -C ~/src/superbuild/build-android/source/openorienteering-mapper-git-master grep "調べたい文字列" || true
