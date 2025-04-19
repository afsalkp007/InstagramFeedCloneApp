//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private let cache = NSCache<NSURL, NSData>()
    private let fileManager = FileManager.default
    private let diskCacheDirectory: URL
    private let queue = DispatchQueue(label: "com.mediaCacheManager.queue", attributes: .concurrent)
    
    private init() {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheDirectory = cacheDirectory.appendingPathComponent("MediaCache")
        try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
    }
    
    func getCachedData(for url: URL, completion: @escaping (Data?) -> Void) {
        queue.async {
            if let cachedData = self.cache.object(forKey: url as NSURL) {
                completion(cachedData as Data)
            } else if let diskData = try? Data(contentsOf: self.diskCachePath(for: url)) {
                self.cache.setObject(diskData as NSData, forKey: url as NSURL)
                completion(diskData)
            } else {
                completion(nil)
            }
        }
    }
    
    func cacheData(_ data: Data, for url: URL) {
        queue.async(flags: .barrier) {
            self.cache.setObject(data as NSData, forKey: url as NSURL)
            try? data.write(to: self.diskCachePath(for: url))
        }
    }
    
    typealias PreLoadCompletion = (() -> Void)?
    
    func preloadData(urls: [URL], completion: PreLoadCompletion) {
        let dispatchGroup = DispatchGroup()
        
        for url in urls {
            dispatchGroup.enter()
            getCachedData(for: url) { cachedData in
                if cachedData == nil {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data {
                            self.cacheData(data, for: url)
                        }
                        dispatchGroup.leave()
                    }.resume()
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    private func diskCachePath(for url: URL) -> URL {
        return diskCacheDirectory.appendingPathComponent(url.lastPathComponent)
    }
}
