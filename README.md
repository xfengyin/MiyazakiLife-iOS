# 🌸 MiyazakiLife iPad 9 IPA 自动构建指南

## 🚀 自动构建说明

项目已配置 GitHub Actions，可以自动构建 IPA 文件！

### ✅ 触发构建的方法

#### 方法一：Push 代码自动构建（推荐 ⭐）

只需将代码推送到 GitHub 的 main 分支，CI/CD 会自动触发构建：

```bash
# 1. 添加所有文件
git add .

# 2. 提交（使用中文也能正常工作）
git commit -m "✨ 优化重构完成，适配 iPad 9"

# 3. 推送到 GitHub
git push origin main
```

#### 方法二：手动触发构建

1. 打开 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 选择 **"Build IPA (Unsigned)"** workflow
4. 点击 **"Run workflow"** 按钮
5. 选择分支（main）并点击运行

### 📋 构建流程

GitHub Actions 会自动执行以下步骤：

```
✅ 1. Checkout code - 检出代码
✅ 2. Select Xcode - 选择 Xcode 15+
✅ 3. Install XcodeGen - 安装项目生成工具
✅ 4. Generate Xcode Project - 生成 Xcode 项目
✅ 5. Build for iOS Simulator - 构建模拟器版本
✅ 6. Build Archive - 构建 Archive
✅ 7. Create IPA - 创建 IPA 文件
✅ 8. Upload Artifacts - 上传构建产物
```

### 📦 下载 IPA 文件

构建成功后：

1. 进入 **Actions** 标签
2. 点击成功的构建记录
3. 在页面底部找到 **Artifacts** 部分
4. 下载 **MiyazakiLife-iPad9-unsigned-IPA**

### 📱 安装 IPA 到 iPad

#### 方法 1：Finder 拖拽（最简单）

1. 用数据线连接 iPad 到 Mac
2. 在 Finder 中打开 iPad
3. 将 IPA 文件拖到 iPad 图标上
4. iPad 会提示安装，确认即可

#### 方法 2：Apple Configurator 2

1. 从 App Store 下载 **Apple Configurator 2**
2. 连接 iPad
3. 打开 Configurator 2
4. 点击 **添加** → 选择 **应用**
5. 选择 IPA 文件

#### 方法 3：Xcode

1. 打开 Xcode
2. Window → **Devices and Simulators**
3. 选择你的 iPad
4. 点击 **+** 按钮
5. 选择 IPA 文件

### ⚙️ 配置要求

#### iPad 要求
- **系统版本:** iPadOS 17.0 或更高
- **设备:** iPad 9、iPad 10、iPad Air、iPad Pro 等
- **存储空间:** 至少 1GB 可用空间

#### GitHub 设置
- 仓库必须是 **Public** 或 **Private**（都可以）
- 无需特殊权限
- 免费账户可用（构建时间有限）

### 🎯 支持的设备

| 设备类型 | 型号 | 状态 |
|---------|------|------|
| **iPad 9** | 10.2-inch (2021) | ✅ 完全支持 |
| **iPad 10** | 10.9-inch (2022) | ✅ 完全支持 |
| **iPad Air** | 第 4/5 代 | ✅ 完全支持 |
| **iPad Pro** | 各尺寸 | ✅ 完全支持 |
| **iPad Mini** | 第 6 代 | ✅ 完全支持 |
| **iPhone** | 所有型号 | ✅ 完全支持 |

### 🔧 自定义构建参数

如果需要指定构建目标，可以在 workflow_dispatch 中选择：

- **iPad** - 优化 iPad 设备
- **iPhone** - 优化 iPhone 设备
- **All** - 构建所有设备版本

### 📊 构建状态说明

| 状态 | 颜色 | 说明 |
|------|------|------|
| ✅ Success | 绿色 | 构建成功，IPA 可用 |
| ❌ Failed | 红色 | 构建失败，查看日志 |
| 🔄 In Progress | 黄色 | 正在构建中 |
| ⏸️ Cancelled | 灰色 | 构建已取消 |

### 🐛 常见问题

#### Q1: 构建失败怎么办？

**A:** 查看构建日志：
1. 点击失败的构建记录
2. 滚动到失败步骤
3. 查看错误信息
4. 根据错误信息修复代码

#### Q2: IPA 下载按钮找不到？

**A:**
1. 确保构建状态是 **Success**
2. 滚动到页面底部 **Artifacts** 部分
3. 点击文件名下载

#### Q3: iPad 无法安装？

**A:**
1. 检查 iPadOS 版本 >= 17.0
2. iPad 需要信任开发者：
   - 设置 → 通用 → VPN与设备管理 → 信任开发者
3. 尝试使用 Apple Configurator 2

#### Q4: 应用崩溃？

**A:**
1. 查看 Xcode 控制台日志
2. 检查网络权限
3. 确保天气 API 可用

### 📞 获取帮助

遇到问题？
1. 查看 [构建指南](docs/iPadBuildGuide.md)
2. 查看 [项目总结](docs/ProjectCompletionSummary.md)
3. 查看 GitHub Actions 日志
4. 提交 Issue

---

**🎉 祝构建成功！**
