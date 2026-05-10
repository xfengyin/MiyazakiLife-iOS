//
//  AppErrors.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation

enum AppError: LocalizedError {
    case invalidURL
    case networkError(underlying: Error?)
    case parseError
    case locationDenied
    case locationNotAvailable
    case noData
    case cacheError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的 URL"
        case .networkError(let underlying):
            return "网络错误" + (underlying != nil ? ": \(underlying!.localizedDescription)" : "")
        case .parseError:
            return "数据解析失败"
        case .locationDenied:
            return "定位服务被拒绝"
        case .locationNotAvailable:
            return "无法获取位置信息"
        case .noData:
            return "暂无数据"
        case .cacheError:
            return "缓存读取失败"
        case .unknownError:
            return "未知错误"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "请检查网络连接后重试"
        case .networkError:
            return "请检查网络连接后重试"
        case .parseError:
            return "数据格式异常，请稍后重试"
        case .locationDenied:
            return "请在设置中启用定位服务"
        case .locationNotAvailable:
            return "请确保位置服务可用"
        case .noData:
            return "请稍后重试"
        case .cacheError:
            return "请清理缓存后重试"
        case .unknownError:
            return "请重启应用后重试"
        }
    }

    var iconName: String {
        switch self {
        case .invalidURL, .networkError:
            return "wifi.slash"
        case .parseError, .cacheError:
            return "exclamationmark.triangle"
        case .locationDenied, .locationNotAvailable:
            return "location.slash"
        case .noData:
            return "tray"
        case .unknownError:
            return "questionmark.circle"
        }
    }
}
