# 老牧师桌宠

macOS 桌面宠物：点击熊猫形象会随机播放八段语录之一，显示相应表情与字幕，并上下压缩回弹。语录一轮内不重复；右键“挑一句”可指定播放。可拖动桌宠、调整音量和大小、停止播放，或让它跟随许家印桌宠的“邦友跳舞”联动。

右键“播放阴乐”可播放单独的背景音乐。音乐播放时形象不会因音乐弹跳，语录仍能同时播放。首次音量为 65%，设置会保存。

## 构建与使用

需要 Apple 芯片、macOS 14 或更新版本，以及 Xcode 命令行工具。运行 `./build.sh`，然后打开 `build/老牧师桌宠.app`。运行 `build/老牧师桌宠.app/Contents/MacOS/LaomushiPet --self-test` 可执行本地功能检查。

公开仓库只包含代码和语录清单。请自行取得并放置有权使用的素材：

- `Assets/face.png`：透明熊猫脸图片。
- `Assets/Expressions/IMG_*.png`：八张透明表情；文件名见 `Sources/main.swift` 的 `expressionFiles` 映射。
- `Assets/Clips/01.m4a` 至 `08.m4a`：八段语录，顺序和文字见 `Assets/clips.json`；时长应与清单一致。
- `Assets/good-boy.mp3`：背景音乐。现有版本的播放入口默认读取这个文件，也可右键“更换阴乐文件…”选择本机其他音频。
- `Assets/AppIcon.icns`：图标。放好 `face.png` 后，运行 `swift Tools/make-icon.swift`，再运行 `iconutil -c icns Work/AppIcon.iconset -o Assets/AppIcon.icns` 生成。

`Tools/extract.swift` 可从本机视频提取 M4A，使用方式为 `swift Tools/extract.swift 输入视频 输出.m4a`。语录原声、表情图、熊猫脸与歌曲均不随公开仓库提供；`LICENSE` 不涵盖这些素材。相关素材的使用和再发布须由使用者自行取得许可。

## 许可

代码以 MIT 许可开源。交互设计含参考其他 MIT 项目的部分，原许可见 `LICENSE-GoodThing` 与 `LICENSE-SunPet`。

应用启动后以及运行期间每天检查一次 GitHub Release；发现较新版本时会询问是否打开发布页面，不会自动下载或安装。需要联网；无 Release 或网络不可用时不提示。
