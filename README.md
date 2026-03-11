# MiyazakiLife iOS

📱 宫崎生活 - 为宫崎居民打造的本地生活助手应用

## 📖 项目介绍

MiyazakiLife 是一款专为日本宫崎市居民设计的 iOS 应用，提供天气查询、生活资讯、本地服务等实用功能，帮助用户更好地享受宫崎生活。

## ✨ 核心功能

### 🌤️ 天气查询
- 实时天气数据
- 小时级预报
- 多日天气预报
- 天气预警通知

### 🏠 首页
- 个性化问候
- 快捷功能入口
- 每日生活提示

### ⚙️ 设置
- 主题切换（浅色/深色/自动）
- 温度单位设置
- 通知管理
- 定位服务配置

## 🛠️ 技术栈

| 技术 | 说明 |
|------|------|
| SwiftUI | 声明式 UI 框架 |
| Combine | 响应式编程 |
| Core Location | 定位服务 |
| URLSession | 网络请求 |
| UserDefaults | 本地存储 |

## 📁 项目结构

```
MiyazakiLife-iOS/
├── MiyazakiLife/
│   ├── App/                    # 应用入口
│   │   └── MiyazakiLifeApp.swift
│   ├── Views/                  # 视图层
│   │   ├── ContentView.swift
│   │   ├── HomeView.swift
│   │   ├── WeatherView.swift
│   │   └── SettingsView.swift
│   ├── Models/                 # 数据模型
│   │   ├── WeatherData.swift
│   │   └── Settings.swift
│   ├── Services/               # 服务层
│   │   └── WeatherService.swift
│   └── Resources/              # 资源文件
│       └── Info.plist
├── README.md
└── .gitignore
```

## 🚀 快速开始

### 环境要求
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd MiyazakiLife-iOS
```

2. 打开项目
```bash
open MiyazakiLife.xcodeproj
```

3. 构建并运行
- 选择目标设备（模拟器或真机）
- 点击 Run (⌘R)

## 📝 开发指南

### 代码规范
- 遵循 Swift 官方代码风格指南
- 使用有意义的变量和函数名
- 添加必要的注释

### 提交规范
```
feat: 新功能
fix: 修复 bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

## 🤝 协作流程

```
用户需求 → Dev-Planner 架构设计 → Dev-Coder 开发 → Dev-Tester 验收 → Media-Creator 传播
```

## 📄 许可证

MIT License

## 👥 团队

- **Dev-Planner** - 架构设计与任务分配
- **Dev-Coder** - 功能开发
- **Dev-Tester** - 测试验收
- **Media-Creator** - 内容传播

---

_宫崎生活，从这里开始。_ 🌴
