#!/bin/bash

# MiyazakiLife iPad 9 IPA 构建脚本
# 作者: Dev-Coder
# 日期: 2026-05-10

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_step() {
    echo -e "${BLUE}[步骤]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

# 检查 XcodeGen 是否安装
check_xcodegen() {
    print_step "检查 XcodeGen..."
    if command -v xcodegen &> /dev/null; then
        local version=$(xcodegen --version)
        print_success "XcodeGen 已安装: $version"
        return 0
    else
        print_error "XcodeGen 未安装"
        echo ""
        echo "请先安装 XcodeGen:"
        echo "  方法1: brew install xcodegen"
        echo "  方法2: npm install -g xcodegen"
        echo ""
        return 1
    fi
}

# 检查 Xcode 是否安装
check_xcode() {
    print_step "检查 Xcode..."
    if command -v xcodebuild &> /dev/null; then
        local version=$(xcodebuild -version | head -n 1)
        print_success "$version"
        return 0
    else
        print_error "Xcode 未安装"
        return 1
    fi
}

# 生成 Xcode 项目
generate_project() {
    print_step "生成 Xcode 项目..."
    if xcodegen generate; then
        print_success "Xcode 项目生成成功"
        return 0
    else
        print_error "Xcode 项目生成失败"
        return 1
    fi
}

# 清理旧的构建文件
clean_build() {
    print_step "清理旧的构建文件..."
    rm -rf build/
    rm -rf ~/Library/Developer/Xcode/DerivedData/MiyazakiLife-*
    print_success "清理完成"
}

# 构建 Archive
build_archive() {
    print_step "构建 Archive (这可能需要几分钟)..."

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
        AD_HOC_CODE_SIGNING_ALLOWED=YES \
        DEVELOPMENT_TEAM="" \
        IPHONEOS_DEPLOYMENT_TARGET=17.0

    if [ $? -eq 0 ]; then
        print_success "Archive 构建成功"
        return 0
    else
        print_error "Archive 构建失败"
        return 1
    fi
}

# 创建 IPA 文件
create_ipa() {
    print_step "创建 IPA 文件..."

    # 创建 Payload 目录
    mkdir -p build/Payload

    # 复制应用文件
    if [ -d "build/MiyazakiLife.xcarchive/Products/Applications/MiyazakiLife.app" ]; then
        cp -r "build/MiyazakiLife.xcarchive/Products/Applications/MiyazakiLife.app" build/Payload/
    else
        # 查找应用文件
        local app_path=$(find build/MiyazakiLife.xcarchive/Products/Applications -name "*.app" -maxdepth 1 | head -1)
        if [ -n "$app_path" ]; then
            cp -r "$app_path" build/Payload/
        else
            print_error "找不到应用文件"
            return 1
        fi
    fi

    # 创建 IPA
    cd build
    zip -r MiyazakiLife-iPad9.ipa Payload/

    if [ $? -eq 0 ]; then
        print_success "IPA 文件创建成功"
        cd ..
        return 0
    else
        print_error "IPA 文件创建失败"
        cd ..
        return 1
    fi
}

# 显示构建结果
show_result() {
    echo ""
    echo "========================================"
    echo "🎉 构建完成！"
    echo "========================================"
    echo ""
    echo "📦 IPA 文件位置:"
    echo "   build/MiyazakiLife-iPad9.ipa"
    echo ""
    echo "📁 文件大小:"
    ls -lh build/MiyazakiLife-iPad9.ipa | awk '{print "   " $5}'
    echo ""
    echo "📋 Archive 位置:"
    echo "   build/MiyazakiLife.xcarchive"
    echo ""
    echo "下一步:"
    echo "1. 使用 Finder 将 IPA 拖拽到 iPad"
    echo "2. 或使用 Xcode → Window → Devices 安装"
    echo "3. 或使用 Apple Configurator 2 安装"
    echo ""
}

# 主函数
main() {
    echo ""
    echo "========================================"
    echo "🌸 MiyazakiLife iPad 9 IPA 构建脚本"
    echo "========================================"
    echo ""

    # 检查依赖
    if ! check_xcode; then
        exit 1
    fi

    if ! check_xcodegen; then
        exit 1
    fi

    # 生成项目
    if ! generate_project; then
        exit 1
    fi

    # 清理旧的构建
    clean_build

    # 构建 Archive
    if ! build_archive; then
        exit 1
    fi

    # 创建 IPA
    if ! create_ipa; then
        exit 1
    fi

    # 显示结果
    show_result

    exit 0
}

# 运行主函数
main "$@"
