//
//  ImageCacheManager.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/10/25.
//

/**
 This file implements a custom image caching solution. The ImageCacheManager class downloads images asynchronously,
 caches them in memory and on disk, and reduces unnecessary network image requests.
 */

import UIKit
import CryptoKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private var memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        if let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            cacheDirectory = caches.appendingPathComponent("ImageCache", isDirectory: true)
        } else {
            fatalError("Could not access caches directory")
        }
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func fileName(for url: URL) -> String {
        let hash = SHA256.hash(data: Data(url.absoluteString.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func fileURL(for url: URL) -> URL {
        return cacheDirectory.appendingPathComponent(fileName(for: url))
    }
    
    func loadImage(for url: URL) async -> UIImage? {
        if let cachedImage = memoryCache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        }
        
        let fileURL = self.fileURL(for: url)
        if fileManager.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: url.absoluteString as NSString)
            return image
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                memoryCache.setObject(image, forKey: url.absoluteString as NSString)
                try? data.write(to: fileURL)
                return image
            }
        } catch {
            print("Error downloading image from \(url): \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        if let filePaths = try? fileManager.contentsOfDirectory(at: cacheDirectory,
                                                                includingPropertiesForKeys: nil) {
            for filePath in filePaths {
                try? fileManager.removeItem(at: filePath)
            }
        }
    }
}

