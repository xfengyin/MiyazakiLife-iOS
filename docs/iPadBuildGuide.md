# 🎯 MiyazakiLife iPad 9 构建指南

## 📋 前置要求

### 硬件要求
- Mac 电脑（macOS 13.0 或更高版本）
- iPad 9 或其他 iPad 设备

### 软件要求
- **Xcode 15.0 或更高版本** （推荐 Xcode 15.2）
- **XcodeGen** 项目生成工具

## 🚀 构建步骤

### 第一步：安装 XcodeGen

打开终端（Terminal），运行以下命令：

```bash
# 使用 Homebrew 安装（推荐）
brew install xcodegen

# 或者使用 npm 安装
npm install -g xcodegen
```

验证安装成功：
```bash
xcodegen --version
```

### 第二步：准备项目文件

1. 确保项目文件夹结构如下：
```
/path/to/MiyazakiLife/
├── project.yml
├── MiyazakiLife/
│   ├── App/
│   ├── Core/
│   ├── Services/
│   ├── ViewModels/
│   ├── Views/
│   ├── Extensions/
│   ├── Utilities/
│   └── Resources/
├── MiyazakiLifeTests/
├── MiyazakiLifeWidget/
└── docs/
```

2. 打开终端，进入项目根目录：
```bash
cd /path/to/MiyazakiLife/
```

### 第三步：生成 Xcode 项目

运行 XcodeGen 生成 Xcode 项目：

```bash
xcodegen generate
```

这将创建 `MiyazakiLife.xcodeproj` 文件。

### 第四步：构建 IPA 文件

#### 方法一：使用命令行构建（推荐）

```bash
# 构建 Archive（生成 xcarchive）
xcodebuild archive \
  -project MiyazakiLife.xcodeproj \
  -scheme MiyazakiLife \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  -archivePath build/MiyazakiLife.xcarchive \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  AD_HOC_CODE_SIGNING_ALLOWED=YES

# 创建 IPA 文件
mkdir -p build/Payload
cp -r "build/MiyazakiLife.xcarchive/Products/Applications/MiyazakiLife.app" build/Payload/
cd build && zip -r MiyazakiLife-iPad9.ipa Payload/
```

#### 方法二：使用 Xcode GUI 构建

1. **打开项目**
   ```bash
   open MiyazakiLife.xcodeproj
   ```

2. **选择目标设备**
   - 在 Xcode 工具栏，选择 "Any iOS Device (arm64)" 作为目标设备

3. **构建 Archive**
   - 点击菜单 **Product → Archive**
   - 等待构建完成

4. **导出 IPA**
   - 在 Organizer 窗口中，选择刚刚创建的 Archive
   - 点击 **Distribute App**
   - 选择 **Development** 或 **Ad Hoc**
   - 按照向导完成导出

### 第五步：安装 IPA 到 iPad

#### 方法一：使用 Xcode 安装

1. 连接 iPad 到 Mac
2. 在 Xcode 中选择 **Window → Devices and Simulators**
3. 选择你的 iPad 设备
4. 点击 **+** 按钮，选择生成的 IPA 文件

#### 方法二：使用 Finder 安装（iPadOS 17+）

1. 连接 iPad 到 Mac
2. 在 Finder 中打开 iPad
3. 拖拽 IPA 文件到 iPad 图标上
4. iPad 会提示安装，确认即可

#### 方法三：使用第三方工具

推荐使用以下工具：
- **Apple Configurator 2**（免费，App Store）
- **AltStore**（免费，需要 Sideloadly 或 AltServer）

## 📱 iPad 9 适配说明

### 项目配置

`project.yml` 已配置为支持 iPad 9：
```yaml
deploymentTarget:
  iOS: "17.0"

targets:
  MiyazakiLife:
    settings:
      base:
        TARGETED_DEVICE_FAMILY: "1,2"  # 支持 iPhone 和 iPad
```

### 界面适配

应用已针对 iPad 进行了优化：
- ✅ 支持 iPad 9 (10.2 英寸 Retina 显示屏)
- ✅ iPadOS 17.0+ 完整支持
- ✅ 键盘和鼠标/触控板支持
- ✅ 多任务分屏支持

### 测试设备建议

推荐测试设备：
- **iPad 9** (10.2-inch, 2021)
- **iPad 10** (10.9-inch, 2022)
- **iPad Air** (第 4/5 代)
- **iPad Pro** (各尺寸)

## 🐛 常见问题

### 问题 1：XcodeGen 找不到

**解决方案：**
```bash
# 重新安装 XcodeGen
brew reinstall xcodegen

# 或使用 npm
npm install -g xcodegen

# 验证
xcodegen --version
```

### 问题 2：构建失败 - 缺少签名

**解决方案：**
- 确保 `project.yml` 中设置了：
  ```yaml
  CODE_SIGN_IDENTITY: ""
  CODE_SIGNING_REQUIRED: "NO"
  CODE_SIGNING_ALLOWED: "NO"
  ```
- 重新生成项目：
  ```bash
  xcodegen generate
  ```

### 问题 3：iPad 无法安装

**解决方案：**
1. 检查 iPad 系统版本 >= iPadOS 17.0
2. 确保 IPA 是为 ARM64 架构构建的
3. 尝试使用 Apple Configurator 2 安装
4. 检查 iPad 存储空间是否充足

### 问题 4：应用崩溃

**解决方案：**
1. 连接 iPad 到 Mac
2. 在 Xcode 中打开 Devices
3. 查看设备日志（Console）
4. 如果是代码问题，重新构建

## 📦 自动构建（GitHub Actions）

项目已配置 GitHub Actions 工作流，可以自动构建 IPA：

1. 推送代码到 GitHub
2. 进入 Actions 页面
3. 选择 "Build IPA (Unsigned)" workflow
4. 点击 "Run workflow"
5. 等待构建完成
6. 下载生成的 IPA 文件

## 🎯 快速验证清单

构建前请确认：

- [ ] macOS 版本 >= 13.0
- [ ] Xcode 版本 >= 15.0
- [ ] XcodeGen 已安装
- [ ] 项目文件完整
- [ ] iPad 系统版本 >= iPadOS 17.0
- [ ] iPad 存储空间充足（> 1GB）

## 📞 获取帮助

如果遇到问题：
1. 检查错误信息
2. 查看 [XcodeGen 文档](https://github.com/yonaskolb/XcodeGen)
3. 查看 [Apple 开发者文档](https://developer.apple.com/)
4. 检查 GitHub Issues

## ✅ 成功标志

构建成功后，你应该能看到：

1. **Archive 构建成功** - Xcode 显示构建完成
2. **IPA 文件生成** - `MiyazakiLife-iPad9.ipa` 文件存在
3. **iPad 安装成功** - 应用出现在主屏幕
4. **应用正常运行** - 应用可以打开并显示天气数据

---

**祝构建成功！🎉**

如果你需要进一步的帮助，随时告诉我。
