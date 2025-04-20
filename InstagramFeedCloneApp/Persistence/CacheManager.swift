//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 20/04/2025.
//

import Foundation

class CacheManager {
    private let fileManager = FileManager.default
    private let diskCacheDirectory: URL
    
    typealias Result = Swift.Result<Data, Error>

    private let queue = DispatchQueue(label: Constants.Cache.queue.value, attributes: .concurrent)
    private let cache = NSCache<NSURL, NSData>()
    
    init() {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheDirectory = cacheDirectory.appendingPathComponent(Constants.Cache.mediaCache.value)
        try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
    }
        
    func getCachedData(for url: URL, completion: @escaping (Result) -> Void) {
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
    
    func cacheData(_ data: Data, for url: URL) {
        queue.async(flags: .barrier) {
            self.cache.setObject(data as NSData, forKey: url as NSURL)
            try? data.write(to: self.diskCachePath(for: url))
        }
    }
    
    func clearCache() {
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
