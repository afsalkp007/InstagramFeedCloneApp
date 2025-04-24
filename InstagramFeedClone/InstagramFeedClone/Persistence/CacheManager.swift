//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 20/04/2025.
//

import Foundation

public protocol CacheService {
    func getCachedData(for url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func cacheData(_ data: Data, for url: URL)
    func clearCache()
}

public final class CacheManager: CacheService {
    private let fileManager: FileManager
    private let diskCacheDirectory: URL
    private let queue: DispatchQueue
    private let cache: NSCache<NSURL, NSData>
    
    public init(fileManager: FileManager = .default, cacheDirectory: URL? = nil) {
        self.fileManager = fileManager
        self.queue = DispatchQueue(label: Constants.Cache.queue.value, attributes: .concurrent)
        self.cache = NSCache<NSURL, NSData>()
        
        let defaultCacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.diskCacheDirectory = cacheDirectory ?? defaultCacheDirectory.appendingPathComponent(Constants.Cache.mediaCache.value)
        try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
    }
    
    public func getCachedData(for url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        queue.async {
            if let cachedData = self.cache.object(forKey: url as NSURL) {
                completion(.success(cachedData as Data))
            } else {
                do {
                    let data = try Data(contentsOf: self.diskCachePath(for: url))
                    self.cache.setObject(data as NSData, forKey: url as NSURL)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func cacheData(_ data: Data, for url: URL) {
        queue.async(flags: .barrier) {
            self.cache.setObject(data as NSData, forKey: url as NSURL)
            try? data.write(to: self.diskCachePath(for: url))
        }
    }
    
    public func clearCache() {
        queue.async(flags: .barrier) {
            self.cache.removeAllObjects()
            do {
                let fileURLs = try self.fileManager.contentsOfDirectory(at: self.diskCacheDirectory, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    try self.fileManager.removeItem(at: fileURL)
                }
            } catch {
                print("Error clearing disk cache: \(error)")
            }
        }
    }
    
    private func diskCachePath(for url: URL) -> URL {
        return diskCacheDirectory.appendingPathComponent(url.lastPathComponent)
    }
}
