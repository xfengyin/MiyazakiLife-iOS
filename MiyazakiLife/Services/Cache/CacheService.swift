//
//  CacheService.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation

final class CacheService: CacheServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let fileManager = FileManager.default

    private lazy var cacheDirectory: URL? = {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("MiyazakiLifeCache")
    }()

    init() {
        createCacheDirectoryIfNeeded()
    }

    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        userDefaults.set(data, forKey: key)
        saveToDisk(data: data, forKey: key)
    }

    func load<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return loadFromDisk(forKey: key)
        }

        if let cached = try? JSONDecoder().decode(CacheEntry<T>.self, from: data),
           !cached.isExpired {
            return cached.value
        }

        return try loadFromDisk(forKey: key)
    }

    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        removeFromDisk(forKey: key)
    }

    func clearAll() {
        let keys = userDefaults.dictionaryRepresentation().keys.filter { $0.hasPrefix("weather_") || $0.hasPrefix("cache_") }
        keys.forEach { userDefaults.removeObject(forKey: $0) }

        if let cacheDir = cacheDirectory {
            try? fileManager.removeItem(at: cacheDir)
            createCacheDirectoryIfNeeded()
        }
    }

    private func saveToDisk(data: Data, forKey key: String) {
        guard let cacheDir = cacheDirectory else { return }
        let fileURL = cacheDir.appendingPathComponent(key.md5Hash)
        try? data.write(to: fileURL)
    }

    private func loadFromDisk<T: Decodable>(forKey key: String) -> T? {
        guard let cacheDir = cacheDirectory else { return nil }
        let fileURL = cacheDir.appendingPathComponent(key.md5Hash)

        guard let data = try? Data(contentsOf: fileURL),
              let cached = try? JSONDecoder().decode(CacheEntry<T>.self, from: data),
              !cached.isExpired else {
            return nil
        }

        return cached.value
    }

    private func removeFromDisk(forKey key: String) {
        guard let cacheDir = cacheDirectory else { return }
        let fileURL = cacheDir.appendingPathComponent(key.md5Hash)
        try? fileManager.removeItem(at: fileURL)
    }

    private func createCacheDirectoryIfNeeded() {
        guard let cacheDir = cacheDirectory else { return }
        if !fileManager.fileExists(atPath: cacheDir.path) {
            try? fileManager.createDirectory(at: cacheDir, withIntermediateDirectories: true)
        }
    }
}

struct CacheEntry<T: Codable>: Codable {
    let value: T
    let timestamp: Date
    let expirationInterval: TimeInterval

    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > expirationInterval
    }

    init(value: T, expirationInterval: TimeInterval = Constants.Cache.diskCacheExpiration) {
        self.value = value
        self.timestamp = Date()
        self.expirationInterval = expirationInterval
    }
}

extension String {
    var md5Hash: String {
        let data = Data(self.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_MD5($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

import CommonCrypto
